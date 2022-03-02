#lang forge/bsl

one sig State {
    root: lone Node -----The root node of the BST tree if it exists
}

sig Node {
    elt: one Int, -----The contents of the Node
    l_child, r_child: lone Node -----The children of the Node if it exists
}

pred ValidStates {
    --- Valid States should follow these rules
    all states : State | {
        some State.root
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

test expect {
    noPredicate: {} is sat
    rootMiddle: {
        ValidStates
        all n : Node | {
            reachable[n, State.root.l_child, l_child, r_child] => State.root.elt > n.elt
            reachable[n, State.root.r_child, l_child, r_child] => State.root.elt < n.elt
        }
        State.root.elt > State.root.l_child.elt
        State.root.elt < State.root.r_child.elt
    } is sat
    rootMiddleLessThan: {
        ValidStates
        all n : Node | {
            reachable[n, State.root.l_child, l_child, r_child]
            reachable[n, State.root.l_child, l_child, r_child] => State.root.elt < n.elt
        }
    } for exactly 3 Node is unsat
    allNodesMiddle: {
        ValidStates
        all disj n1, n2 : Node | {
            reachable[n1, n2.l_child, l_child, r_child] => n2.elt > n1.elt
            reachable[n1, n2.r_child, l_child, r_child] => n2.elt < n1.elt
            some n2.l_child => n2.elt > n2.l_child.elt
            some n2.r_child => n2.elt < n2.r_child.elt
        }
    } for exactly 10 Node is sat
    allNodesMiddleNoGreater: {
        ValidStates
        // checks right child exists
        some n : Node | {
            some n.r_child
        }
        all disj n1, n2 : Node | {
            reachable[n1, n2.l_child, l_child, r_child] => n2.elt > n1.elt
            reachable[n1, n2.r_child, l_child, r_child] => n2.elt > n1.elt
            some n2.l_child => n2.elt > n2.l_child.elt
            some n2.r_child => n2.elt > n2.r_child.elt
        }
    } for exactly 10 Node is unsat
    unBalancedTreeLeft: {
        ValidStates
        all disj n1, n2 : Node | {
            reachable[n1, n2.l_child, l_child, r_child] => n2.elt > n1.elt
            reachable[n1, n2.r_child, l_child, r_child] => n2.elt > n1.elt
            some n2.l_child => n2.elt > n2.l_child.elt
            some n2.r_child => n2.elt > n2.r_child.elt
        }
    } for exactly 10 Node is sat
    noSameChild: {
        ValidStates
        some n : Node {
            // if two child exist, can't be same
            some n.l_child
            some n.r_child
            (some n.l_child and some n.r_child) => n.l_child = n.r_child
        }
    } is unsat
    noSameEle: {
        ValidStates
        all disj n1, n2 : Node {
            n1.elt = n2.elt
        } 
    } for exactly 10 Node is unsat
    


}

run {
    ValidStates
} for exactly 10 Node