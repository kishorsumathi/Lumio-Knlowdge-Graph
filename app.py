import json
import os
import streamlit as st
from dotenv import load_dotenv

from src.graph.neo4j_client import get_driver, run_cypher, get_graph_data, get_schema_text
from src.llm.groq_client import english_to_cypher, explain_results
from src.ui.graph_renderer import build_pyvis_graph, render_graph, render_legend

load_dotenv()

# --- Config ---
NEO4J_URI = os.getenv("NEO4J_URI")
NEO4J_USERNAME = os.getenv("NEO4J_USERNAME")
NEO4J_PASSWORD = os.getenv("NEO4J_PASSWORD")
NEO4J_DATABASE = os.getenv("NEO4J_DATABASE")
GROQ_API_KEY = os.getenv("GROQ_API_KEY")

# Load quick queries
with open("config/quick_queries.json") as f:
    QUICK_QUERIES = json.load(f)

# --- Page config ---
st.set_page_config(page_title="Lumio Knowledge Graph", layout="wide", page_icon="🧠")

st.markdown("""
<style>
    .stApp { background-color: #0E1117; }
    .block-container { padding-top: 2rem; }
    div[data-testid="stTextInput"] input {
        background-color: #1E1E2E;
        color: white;
        border: 1px solid #333;
        border-radius: 10px;
        padding: 12px;
    }
</style>
""", unsafe_allow_html=True)

st.title("Lumio Knowledge Graph Explorer")

# --- Neo4j driver ---
driver = get_driver(NEO4J_URI, NEO4J_USERNAME, NEO4J_PASSWORD)

# --- Load story ---
@st.cache_data
def load_story():
    with open("stories/rahul_journey.md") as f:
        return f.read()

@st.dialog("Rahul's Journey — A Therapy Story", width="large")
def show_story():
    # Close button at top
    if st.button("Close", type="primary", use_container_width=True, key="close_top"):
        st.rerun()
    st.markdown(load_story(), unsafe_allow_html=True)

# --- Sidebar ---
with st.sidebar:
    if st.button("Read Rahul's Story", use_container_width=True, type="secondary"):
        show_story()

    st.markdown("---")
    render_legend()
    st.markdown("---")
    st.markdown("### Quick Queries")
    for btn_label, cypher in QUICK_QUERIES.items():
        if st.button(btn_label, use_container_width=True):
            st.session_state["run_quick"] = {"label": btn_label, "cypher": cypher}

# --- Main area ---
query = st.text_input(
    "Ask anything about the knowledge graph in plain English:",
    placeholder="e.g., Is Rahul getting better? / Show me Rahul's care team / What triggers his anxiety?",
)
search_btn = st.button("Search", type="primary", use_container_width=True)

# --- Load schema once ---
if "schema" not in st.session_state:
    with st.spinner("Loading schema..."):
        st.session_state["schema"] = get_schema_text(driver, NEO4J_DATABASE)


def execute_and_display(cypher, question=None):
    """Run cypher, show graph + explanation."""
    st.markdown("**Cypher:**")
    st.code(cypher, language="cypher")
    try:
        with st.spinner("Querying Neo4j..."):
            nodes, edges = get_graph_data(driver, NEO4J_DATABASE, cypher)
            table_results = run_cypher(driver, NEO4J_DATABASE, cypher)

        if nodes:
            net = build_pyvis_graph(nodes, edges)
            render_graph(net, nodes, edges)
            st.success(f"{len(nodes)} nodes, {len(edges)} relationships")
        elif table_results:
            st.dataframe(table_results)
        else:
            st.warning("No results found. Try rephrasing your question.")

        if question and table_results:
            with st.spinner("Generating explanation..."):
                explanation = explain_results(question, table_results, GROQ_API_KEY)
            st.markdown("---")
            st.markdown(f"**Answer:** {explanation}")
    except Exception as e:
        st.error(f"Query failed: {e}")
        st.info("Try rephrasing your question or use a quick query from the sidebar.")


# --- Quick query from sidebar ---
if "run_quick" in st.session_state:
    quick = st.session_state.pop("run_quick")
    st.markdown(f"### {quick['label']}")
    execute_and_display(quick["cypher"], quick["label"])

# --- English search ---
elif search_btn and query:
    with st.spinner("Translating to Cypher..."):
        cypher = english_to_cypher(query, st.session_state["schema"], GROQ_API_KEY)
    execute_and_display(cypher, query)
