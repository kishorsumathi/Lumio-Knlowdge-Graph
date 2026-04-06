import re
import json
import os
from groq import Groq

PROMPTS_DIR = os.path.join(os.path.dirname(__file__), "..", "prompts")

# Model config — change here to switch models
MODEL = "openai/gpt-oss-120b"


def _load_prompt(name):
    path = os.path.join(PROMPTS_DIR, name)
    with open(path) as f:
        return f.read()


def _get_client(api_key):
    return Groq(api_key=api_key)


def english_to_cypher(question, schema, api_key):
    """Convert English question to a single valid Cypher query."""
    client = _get_client(api_key)
    # Embed the full schema into the prompt
    system_prompt = _load_prompt("cypher_generation.txt")
    system_prompt = system_prompt.replace("{schema}", f"\n\nACTUAL DATABASE SCHEMA:\n{schema}")

    response = client.chat.completions.create(
        model=MODEL,
        messages=[
            {"role": "system", "content": system_prompt},
            {"role": "user", "content": question},
        ],
        temperature=0,
    )

    cypher = response.choices[0].message.content.strip()
    cypher = cypher.strip("`").replace("cypher\n", "").replace("cypher", "").strip()
    # Collapse to single line
    cypher = " ".join(l.strip() for l in cypher.split("\n") if l.strip())

    # Safety checks for common LLM errors
    return_count = len(re.findall(r'\bRETURN\b', cypher, re.IGNORECASE))

    # Check 1: Multiple RETURNs or UNION (multiple queries)
    if return_count > 1 or "UNION" in cypher.upper():
        name_match = re.search(r"name:\s*'([^']+)'", cypher)
        if name_match:
            name = name_match.group(1)
            cypher = f"MATCH (m:Member {{name:'{name}'}})-[r]->(x) RETURN m, r, x LIMIT 100"
        else:
            cypher = "MATCH (a)-[r]->(b) RETURN a, r, b LIMIT 100"
        return cypher

    # Check 2: Relationship variable used but not captured
    # Pattern: RETURN ... r ... but no [r] or [r:TYPE] in MATCH
    return_clause = cypher.split("RETURN")[1] if "RETURN" in cypher else ""
    if "r" in return_clause.lower() and not re.search(r'\[\s*r\s*[:\]]', cypher):
        # Fix: add [r] to relationships that are missing it
        cypher = re.sub(r'-\[:\s*([A-Z_]+)\s*\]->', r'-[r:\1]->', cypher)

    return cypher


def explain_results(question, results, api_key):
    """Use LLM to explain query results in plain English."""
    client = _get_client(api_key)
    system_prompt = _load_prompt("explain_results.txt")
    summary = json.dumps(results[:20], indent=2, default=str)

    response = client.chat.completions.create(
        model=MODEL,
        messages=[
            {"role": "system", "content": system_prompt},
            {"role": "user", "content": f"Question: {question}\n\nData:\n{summary}"},
        ],
        temperature=0.3,
    )
    return response.choices[0].message.content.strip()
