import json
import os
import tempfile
import streamlit as st
from pyvis.network import Network

NODE_COLORS = {
    "Member": "#4C8BF5",
    "Therapist": "#34A853",
    "Psychiatrist": "#EA4335",
    "CareCoordinator": "#FBBC04",
    "FamilyMember": "#FF6D01",
    "Diagnosis": "#AB47BC",
    "Symptom": "#E53935",
    "Medication": "#00ACC1",
    "TherapyType": "#43A047",
    "TherapeuticTechnique": "#7CB342",
    "Session": "#5C6BC0",
    "Assessment": "#F4511E",
    "CarePlan": "#00897B",
    "Transcription": "#8D6E63",
    "JournalEntry": "#FFB300",
    "MoodLog": "#D81B60",
    "Topic": "#6D4C41",
    "Insight": "#1E88E5",
}

NODE_SIZES = {
    "Member": 40,
    "Session": 20,
    "Transcription": 12,
}


def build_pyvis_graph(nodes, edges, height="700px"):
    net = Network(
        height=height,
        width="100%",
        bgcolor="#0E1117",
        font_color="white",
        directed=True,
        notebook=False,
    )

    net.set_options("""
    {
      "physics": {
        "forceAtlas2Based": {
          "gravitationalConstant": -100,
          "centralGravity": 0.005,
          "springLength": 250,
          "springConstant": 0.02,
          "damping": 0.4,
          "avoidOverlap": 0.8
        },
        "solver": "forceAtlas2Based",
        "stabilization": {"enabled": true, "iterations": 200},
        "minVelocity": 0.75
      },
      "interaction": {
        "hover": true,
        "tooltipDelay": 100,
        "zoomView": true,
        "dragView": true,
        "navigationButtons": true
      },
      "edges": {
        "smooth": {"type": "continuous", "roundness": 0.3}
      }
    }
    """)

    for node in nodes:
        group = node["group"]
        color = NODE_COLORS.get(group, "#999999")
        size = NODE_SIZES.get(group, 28)

        net.add_node(
            node["id"],
            label=node["label"],
            color={
                "background": color,
                "border": color,
                "highlight": {"background": "#ffffff", "border": color},
                "hover": {"background": color, "border": "#ffffff"},
            },
            size=size,
            title=node["label"],
            font={"size": 13, "color": "white", "strokeWidth": 3, "strokeColor": "#0E1117"},
            borderWidth=2,
            borderWidthSelected=5,
            shape="dot",
            shadow=True,
        )

    for edge in edges:
        net.add_edge(
            edge["from"],
            edge["to"],
            label=edge["label"],
            color={"color": "#555555", "highlight": "#ffffff", "hover": "#888888"},
            font={"size": 10, "color": "#aaaaaa", "align": "middle", "strokeWidth": 2, "strokeColor": "#0E1117"},
            arrows={"to": {"enabled": True, "scaleFactor": 0.8}},
            width=1.5,
            hoverWidth=3,
            selectionWidth=3,
        )

    return net


def render_graph(net, nodes=None, edges=None):
    """Render pyvis graph in Streamlit with click-to-inspect panel."""
    nodes = nodes or []
    edges = edges or []

    with tempfile.NamedTemporaryFile(delete=False, suffix=".html", mode="w") as f:
        net.save_graph(f.name)
        with open(f.name, "r") as html_file:
            html_content = html_file.read()

        # Build node data lookup for click panel
        node_data_json = json.dumps({
            n["id"]: {
                "label": n["label"],
                "group": n["group"],
                "props": {k: str(v) for k, v in n["props"].items()},
                "color": NODE_COLORS.get(n["group"], "#999"),
            }
            for n in nodes
        })

        details_panel = f"""
        <div id="node-details" style="
            position:absolute;
            background:#1a1a2e; border:1px solid #555; border-radius:10px;
            padding:14px; min-width:240px; max-width:320px; max-height:350px;
            overflow-y:auto; display:none; z-index:9999;
            box-shadow: 0 4px 20px rgba(0,0,0,0.7);
            font-family: -apple-system, BlinkMacSystemFont, sans-serif;
            pointer-events: auto;
        ">
            <div style="display:flex;justify-content:space-between;align-items:center;margin-bottom:8px;">
                <span id="detail-title" style="color:#4C8BF5;font-size:14px;font-weight:bold;"></span>
                <span id="detail-close" style="color:#888;cursor:pointer;font-size:16px;padding:0 4px;">&#10005;</span>
            </div>
            <div id="detail-type" style="color:#888;font-size:10px;text-transform:uppercase;letter-spacing:1px;margin-bottom:8px;"></div>
            <div id="detail-content" style="color:#ccc;font-size:12px;line-height:1.6;"></div>
        </div>

        <script type="text/javascript">
        (function() {{
            var _nodeData = {node_data_json};
            var _lastClickX = 0;
            var _lastClickY = 0;

            // Track mouse position on the canvas
            var container = document.getElementById("mynetwork");
            if (container) {{
                container.addEventListener("click", function(e) {{
                    _lastClickX = e.clientX;
                    _lastClickY = e.clientY;
                }});
            }}

            document.getElementById("detail-close").addEventListener("click", function() {{
                document.getElementById("node-details").style.display = "none";
            }});

            function positionPanel(panel) {{
                // Position near the click, offset slightly right and below
                var x = _lastClickX + 15;
                var y = _lastClickY - 20;

                // Keep panel within viewport
                var pw = 320;
                var ph = 350;
                var vw = window.innerWidth;
                var vh = window.innerHeight;

                if (x + pw > vw) x = _lastClickX - pw - 15;
                if (y + ph > vh) y = vh - ph - 10;
                if (y < 10) y = 10;
                if (x < 10) x = 10;

                panel.style.position = "fixed";
                panel.style.left = x + "px";
                panel.style.top = y + "px";
            }}

            function showPanel(panel) {{
                positionPanel(panel);
                panel.style.display = "block";
            }}

            function attachClickHandler(net) {{
                net.on("click", function(params) {{
                    var panel = document.getElementById("node-details");
                    if (params.nodes.length > 0) {{
                        var nodeId = params.nodes[0];
                        var data = _nodeData[nodeId];
                        if (data) {{
                            document.getElementById("detail-title").textContent = data.label;
                            document.getElementById("detail-title").style.color = data.color;
                            document.getElementById("detail-type").textContent = data.group;
                            var html = "";
                            for (var key in data.props) {{
                                var val = data.props[key];
                                if (val.length > 80) val = val.substring(0, 80) + "...";
                                html += "<div style='margin:3px 0;padding:3px 0;border-bottom:1px solid #333;'>";
                                html += "<span style='color:#888;font-size:10px;'>" + key + "</span><br>";
                                html += "<span style='color:#fff;font-size:12px;'>" + val + "</span>";
                                html += "</div>";
                            }}
                            document.getElementById("detail-content").innerHTML = html;
                            showPanel(panel);
                        }}
                    }} else if (params.edges.length > 0) {{
                        var edgeId = params.edges[0];
                        var visEdge = net.body.data.edges.get(edgeId);
                        if (visEdge) {{
                            var fromData = _nodeData[visEdge.from];
                            var toData = _nodeData[visEdge.to];
                            document.getElementById("detail-title").textContent = visEdge.label || "Relationship";
                            document.getElementById("detail-title").style.color = "#4C8BF5";
                            document.getElementById("detail-type").textContent = "RELATIONSHIP";
                            var html = "<div style='margin:6px 0;'>";
                            html += "<span style='color:" + (fromData ? fromData.color : "#fff") + ";'>" + (fromData ? fromData.label : "?") + "</span>";
                            html += " <span style='color:#666;'>&rarr;</span> ";
                            html += "<span style='color:" + (toData ? toData.color : "#fff") + ";'>" + (toData ? toData.label : "?") + "</span>";
                            html += "</div>";
                            document.getElementById("detail-content").innerHTML = html;
                            showPanel(panel);
                        }}
                    }} else {{
                        panel.style.display = "none";
                    }}
                }});
            }}

            // Find the network instance
            var attempts = 0;
            var finder = setInterval(function() {{
                attempts++;
                if (attempts > 50) {{ clearInterval(finder); return; }}
                if (typeof network !== "undefined") {{ clearInterval(finder); attachClickHandler(network); return; }}
                var containers = document.querySelectorAll(".vis-network");
                for (var i = 0; i < containers.length; i++) {{
                    var c = containers[i];
                    if (c && c.parentElement && c.parentElement.__vis_network) {{
                        clearInterval(finder);
                        attachClickHandler(c.parentElement.__vis_network);
                        return;
                    }}
                }}
            }}, 100);
        }})();
        </script>
        """
        html_content = html_content.replace("</body>", details_panel + "</body>")
        st.components.v1.html(html_content, height=720, scrolling=False)
        os.unlink(f.name)


def render_legend():
    """Render color legend in sidebar."""
    st.markdown("### Node Types")
    for label, color in NODE_COLORS.items():
        st.markdown(
            f'<div style="display:flex;align-items:center;gap:8px;margin:4px 0;">'
            f'<div style="width:14px;height:14px;border-radius:50%;background:{color};"></div>'
            f'<span style="color:white;font-size:14px;">{label}</span></div>',
            unsafe_allow_html=True,
        )
