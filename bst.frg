#lang forge/bsl

sig State {
    root: lone Node, -----The root node of the BST tree if it exists
    next: lone State -----Every state has at most one next state
}

sig Node {
    elt: one Int, -----The contents of the Node
    l_child, r_child: lone Node -----The children of the Node if it exists
}

pred ValidStates {
    --- Valid States should follow these rules
    all states : State | {
        all nodes : Node | {
            // nodes should not point to themselves
            not reachable[nodes, nodes, l_child, r_child]
            // if not the root, must be reachable from root
            nodes != states.root => reachable[nodes, states.root, l_child, r_child]
            // makes sure that no node can reach the root(bc that doesn't make it a root)
            not reachable[states.root, nodes, l_child, r_child]
            // if right and left child don't exist, should not be the same
            (some nodes.r_child and some nodes.l_child) => nodes.r_child != nodes.l_child
         }   
        --- 2. Every Node has a unique number (no repeats)
        all disj n1, n2 : Node |  {
            n1.elt != n2.elt
            --- 3. Every Node to the left of a parent is less than that parent
            some n1.l_child => {
                // left child of node must be less than current 
                n1.l_child.elt < n1.elt
                 --- if node has a left node, check to see if node is reachable, if it is should be <
                (reachable[n2, n1.l_child, l_child, r_child] => n2.elt < n1.elt)

            }
            --- 4. Every Node to the right of a parent is greater than that parent
            some n1.r_child => {
                // right child of node must be greater than current
                n1.r_child.elt > n1.elt
                (reachable[n2, n1.r_child, l_child, r_child] => n2.elt > n1.elt)

            }
        }
    }


    --- I believe that's it    
}

// pred Insert[pre: State, post: State] {
//     --- Inserting into a BST should follow these rules
//     --- 1. Everything that was in the pre-state should be in 
//     --- the post-state in the same position
//     --- 2. The number of Nodes should increase by 1
// }

// pred Remove[pre: State, post: State] {
//     --- Inserting into a BST should follow these rules
//     --- 1. Everything that was in the pre-state should be in 
//     --- the post-state in the same position
//     --- 2. The number of Nodes should decrease by 1
// }

pred BSTTransitionStates {

}

run {
    ValidStates
} for exactly 1 State, exactly 3 Node