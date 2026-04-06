# Knowledge Graph Basics — For Anchor

## What is a Knowledge Graph?

Think of it like a **mind map** on steroids.

You know how in a mind map you draw circles (things) and lines between them (connections)? A knowledge graph is exactly that, but stored in a database so a computer can search it.

```
Simple mind map:

    [Rahul] ----sees----> [Dr. Sharma]
       |                      |
    has problem          specializes in
       |                      |
    [Anxiety] <---treats--- [CBT]
```

That's literally a knowledge graph. Four circles, four lines.

In database language:
- The **circles** are called **Nodes** (things/objects)
- The **lines** are called **Relationships** (how things connect)
- The **labels on lines** tell you WHAT the connection means

---

## Why Do We Need This For Anchor?

Imagine Anchor has 1000 members, each with 20+ therapy sessions. That's 20,000+ session transcripts. A therapist asks:

> "Has Rahul's sleep gotten better since we started the medication?"

**Without a knowledge graph** (just text search):
- Search "Rahul" + "sleep" across 20,000 transcripts
- Get 50 random results mentioning sleep
- No idea which medication, when it started, or if sleep improved
- Can't connect the dots

**With a knowledge graph:**
- Find Rahul (node) → connected to Sertraline (medication node) → started Jan 15
- Find Rahul → connected to "insomnia" (symptom node) → first reported Session 3
- Find Rahul → connected to Sessions 1-8 → each has mood scores
- Find Sertraline → CAUSES → nausea (side effect)
- **Answer in seconds**: "Sleep improved from 2-3 hrs to 5-6 hrs after starting Sertraline, but regressed after dose increase"

The graph **connects the dots** that text search cannot.

---

## What is Neo4j?

Neo4j is the **database** where we store our knowledge graph. Think of it as:
- **Excel** stores tables (rows and columns)
- **Neo4j** stores circles and lines (nodes and relationships)

We use a language called **Cypher** to ask questions. It looks like this:

```
Find Rahul:
  MATCH (r:Member {name: "Rahul"}) RETURN r

Find who treats Rahul:
  MATCH (r:Member {name: "Rahul"})-[:TREATED_BY]->(doc) RETURN doc

Find all of Rahul's symptoms:
  MATCH (r:Member {name: "Rahul"})-[:EXHIBITS]->(s:Symptom) RETURN s
```

The arrows `->` show direction. The `[:TREATED_BY]` is the relationship name.

---

## What is Weaviate?

Weaviate is a **different** database — it stores TEXT and lets you search by MEANING.

Example: If you search for "feeling down", Weaviate will also find text that says "I'm sad" or "everything feels hopeless" — because it understands they mean similar things.

**Neo4j** = stores structured facts (Rahul takes Sertraline, scored 18 on PHQ-9)
**Weaviate** = stores the actual conversation text and searches by meaning

We use BOTH because some questions need facts (Neo4j) and some need text search (Weaviate).

---

## The Anchor Story — Explained Simply

Let's follow one person through the entire system. No medical jargon — I'll explain everything.

### The People

**Rahul** — A 28-year-old guy who feels anxious all the time and can't sleep. He joins Anchor for help.

**Dr. Sharma** — A therapist. She talks to Rahul weekly to help him understand his feelings and learn coping techniques. Think of her as a "talking doctor."

**Dr. Mehta** — A psychiatrist. He prescribes medication. Think of him as a "medicine doctor."

**Anita** — A care coordinator. She makes sure everything runs smoothly — appointments, follow-ups, connecting Rahul to the right people. Think of her as a "project manager for care."

**Priya** — Rahul's wife. She wants to support him and track his progress.

### What Happens to Rahul

```
Week 1:  Rahul signs up → Gets matched with Dr. Sharma + Dr. Mehta
Week 1:  First session (intake) → Dr. Sharma talks to him, figures out he has anxiety
Week 1:  Dr. Mehta prescribes Sertraline (an anti-anxiety pill)
Week 2:  Session 2 → They start CBT (a technique where you learn to catch negative thoughts)
Week 3:  Session 3 → Rahul mentions he can't sleep
Week 4:  Session 4 → Rahul tries a "Thought Record" exercise (writing down worries to challenge them)
Week 5:  Session 5 → Rahul says sleep is better! Pill is working
Week 8:  Session 8 → Dose increased, now he feels nauseous. Sleep got worse again.
```

Every single event above creates **nodes** and **relationships** in our graph.
