#lang forge/bsl

sig State {
    root: lone Node -----The root node of the BST tree if it exists
    next: lone State -----Every state has at most one next state
}

sig Node {
    elt: one Int, -----The contents of the Node
    l_child, r_child: lone Node, -----The children of the Node if it exists
}

pred ValidStates {
    --- Valid States should follow these rules
    --- 1. Every Node is reachable from the root node
    --- 2. Every Node has a unique number (no repeats)
    --- 3. Every Node to the left of a parent is less than that parent
    --- 4. Every Node to the right of a parent is greater than that parent
    --- I believe that's it    
}

pred Insert[pre: State, post: State] {
    --- Inserting into a BST should follow these rules
    --- 1. Everything that was in the pre-state should be in 
    --- the post-state in the same position
    --- 2. The number of Nodes should increase by 1
}

pred Remove[pre: State, post: State] {
    --- Inserting into a BST should follow these rules
    --- 1. Everything that was in the pre-state should be in 
    --- the post-state in the same position
    --- 2. The number of Nodes should decrease by 1
}

pred BSTTransitionStates {
    --- BSTTransitionStates should follow these rules
    --- 1. all states should transition with either Insert or Remove
    --- 2. 
}

run {
    ValidStates
    BSTTransitionStates
}