import pandas as pd
import networkx as nx


# 1. Read the list of nodes and dates from the file
# sep=r'\s+' automatically handles single or multiple spaces safely
nodes = pd.read_csv(
    "./data/hep-th-slacdates.tar.gz", 
    sep=r'\s+', 
    header=None, 
    names=["id", "date"], 
    dtype=str  # Forces character/string type matching R's colClasses
)

# 2. Read the list of edges from the file
edges = pd.read_csv(
    "./data/hep-th-citations.tar.gz", 
    sep=r'\s+', 
    header=None, 
    names=["from", "to"], 
    dtype=str
)

# 3. Get unique node IDs from both columns of the edge list
node_ids = pd.unique(edges[["from", "to"]].values.ravel())

# 4. Get actual nodes listed in edge list
nodes_used = nodes[nodes["id"].isin(node_ids)].copy()

# # ==========================================
# # CRITICAL FIX: Prune duplicate vertex rows 
# # ==========================================
# # This keeps the first occurrence and drops the duplicates, mirroring R's behavior
# nodes_used = nodes_used.drop_duplicates(subset=["id"], keep="first")

# 5. Make a directed graph smoothly
g_directed = nx.DiGraph()

# Convert the filtered nodes dataframe into a dictionary of attributes and load them
node_attributes = nodes_used.set_index("id").to_dict("index")
g_directed.add_nodes_from(node_attributes.keys())
nx.set_node_attributes(g_directed, node_attributes)

# Add the edges directly from the edge dataframe tuples
g_directed.add_edges_from(edges.itertuples(index=False, name=None))

# Print properties to verify success
print("--- GRAPH INITIALIZATION SUCCESSFUL ---")
print(f"Nodes in graph: {g_directed.number_of_nodes()}")
print(f"Edges in graph: {g_directed.number_of_edges()}")