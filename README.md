# cs1710-curiosity-modeling
What are you trying to model? Include a brief description that would give someone unfamiliar with the topic a basic understanding of your goal.

This project was meant to model what a valid Binary Search Tree should look like. That means that for a given tree of with n nodes, a BST should only have one root node, 1 left and 1 right child (Node or a Leaf), and everything to the left of a node should be less than that node, everything to the right of that node should be greater than that node. We aren't modeling the different ways our tree could be updated (Insertion, Removal, Updating) but simply just the properties of a valid BST.

Give an overview of your model design choices, what checks or run statements you wrote, and what we should expect to see from an instance produced by Sterling. How should we look at and interpret an instance created by your spec?

We decided to represent our tree as two sigs, Node and State. Initially, 
we had the intention of modeling insertion and deletion, hence the states, however, this proved difficult because if states shared a similar root node, inserting a new node into one state makes the previous state invalid they share the same root node. We kept the State sig to generalize our BST making it easier to pick up Insertion and Deletion transitions if we really wanted to. These were just ideas but we believed that potentially having a set of nodes per state and enforcing that everything reachable from the root node should be within this set of nodes for this particular state would
help with implementing Insertion/Deletion. We have a simple run statement that runs the ValidStates predicate enforces that a single state is generated. To better digest an instance of a valid BST in sterling we recommend using the bst_vis.js file to visualize the tree. Due to the limitations of sterling (can't pan/the canvas is small), visualizing a tree with more than ten nodes will start making the tree incomprehensible as nodes start to bunch together.

At a high level, what do each of your sigs and preds represent in the context of the model? Justify the purpose for their existence and how they fit together.

State Sig - Keeps track of a singular root node for the BST for that state as well as the following states in case transition states are implemented. State sig isn't truly necessary since we aren't modeling transitions but at the very least it holds the place of our root node

Node Sig - Keeps track of the contents of a singular node as well as what it's left and right children are. This contains our entire BST.

ValidState Pred - Determines whether an instance of a BST meets the following criteria: Nodes don't point to themselves, all nodes must be reachable from the root, no node can reach the root, left child an right child shouldn't be the same, every node has a unique number, every node to the left of the parent is less than the parent, and every node to the right of the parent is greater than the parent. Without this predicate, we would have a jumbled mess of a BST. This constrains our model to be a BST.
