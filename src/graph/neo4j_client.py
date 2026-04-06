import json
import streamlit as st
from neo4j import GraphDatabase


@st.cache_resource
def get_driver(uri, username, password):
    return GraphDatabase.driver(uri, auth=(username, password))


def run_cypher(driver, database, query, params=None):
    with driver.session(database=database) as session:
        result = session.run(query, params or {})
        return [record.data() for record in result]


def _node_display_name(label, props):
    """Build a readable display name for any node type."""
    if props.get("name"):
        return props["name"]
    if label == "Session":
        num = props.get("number", "?")
        stype = props.get("type", "")
        return f"Session {num} ({stype})" if stype else f"Session {num}"
    if label == "Assessment":
        tool = props.get("tool", "Test")
        score = props.get("score", "?")
        return f"{tool}: {score}"
    if label == "CarePlan":
        ver = props.get("version", "?")
        return f"Care Plan v{ver}"
    if label == "Insight":
        text = props.get("text", "")
        return text[:45] + "..." if len(text) > 45 else text
    if label == "JournalEntry":
        date = props.get("date", "")
        return f"Journal ({date})" if date else "Journal Entry"
    if label == "MoodLog":
        mood = props.get("mood", "")
        date = props.get("date", "")
        return f"Mood: {mood} ({date})" if mood else "Mood Log"
    if label == "Transcription":
        sid = props.get("session_id", "")
        return f"Transcript {sid}" if sid else "Transcript"
    if label == "Medication":
        return props.get("generic_name") or props.get("brand_name") or "Medication"
    # Fallback
    for key in ["name", "text", "tool", "generic_name", "abbreviation", "id"]:
        if props.get(key):
            val = str(props[key])
            return val[:40] if len(val) > 40 else val
    return label


def get_graph_data(driver, database, query, params=None):
    """Run a Cypher query and extract nodes + relationships for visualization."""
    nodes = {}
    edges = []

    with driver.session(database=database) as session:
        result = session.run(query, params or {})
        for record in result:
            for value in record.values():
                if hasattr(value, "labels"):  # Node
                    node_id = value.element_id
                    label = list(value.labels)[0] if value.labels else "Unknown"
                    props = dict(value)
                    display = _node_display_name(label, props)
                    nodes[node_id] = {
                        "id": node_id,
                        "label": display,
                        "group": label,
                        "props": props,
                    }
                elif hasattr(value, "type"):  # Relationship
                    edges.append({
                        "from": value.start_node.element_id,
                        "to": value.end_node.element_id,
                        "label": value.type,
                        "props": dict(value),
                    })
                    for node in [value.start_node, value.end_node]:
                        nid = node.element_id
                        if nid not in nodes:
                            nlabel = list(node.labels)[0] if node.labels else "Unknown"
                            nprops = dict(node)
                            display = _node_display_name(nlabel, nprops)
                            nodes[nid] = {
                                "id": nid,
                                "label": display,
                                "group": nlabel,
                                "props": nprops,
                            }

    return list(nodes.values()), edges


def get_schema_text(driver, database):
    """Get rich schema with ALL distinct node values and relationship patterns."""
    node_info = run_cypher(driver, database,
        "CALL db.labels() YIELD label RETURN collect(label) AS labels"
    )
    labels = node_info[0]["labels"] if node_info else []

    schema_parts = []
    for label in labels:
        # Get property names from one sample
        props = run_cypher(driver, database,
            f"MATCH (n:`{label}`) RETURN properties(n) AS props LIMIT 1"
        )
        if not props:
            continue

        prop_keys = list(props[0]["props"].keys())

        # Identify the "name" property for this label (priority: name, generic_name, brand_name)
        name_prop = None
        for candidate in ["name", "generic_name", "brand_name"]:
            if candidate in prop_keys:
                name_prop = candidate
                break

        # If we found a name property, fetch all distinct values
        if name_prop:
            values = run_cypher(driver, database,
                f"MATCH (n:`{label}`) RETURN DISTINCT n.{name_prop} AS value LIMIT 100"
            )
            value_list = [v["value"] for v in values if v["value"]]
            schema_parts.append(
                f"(:{label}) — {name_prop}: {value_list}"
            )
        else:
            # No identifying property, just show structure
            schema_parts.append(
                f"(:{label}) — properties: {prop_keys}"
            )

    rel_patterns = run_cypher(driver, database,
        "MATCH (a)-[r]->(b) "
        "WITH labels(a)[0] AS from_label, type(r) AS rel, labels(b)[0] AS to_label "
        "RETURN DISTINCT from_label, rel, to_label LIMIT 50"
    )
    schema_parts.append("\nRelationship patterns:")
    for p in rel_patterns:
        schema_parts.append(f"  (:{p['from_label']})-[:{p['rel']}]->(:{p['to_label']})")

    return "\n".join(schema_parts)
