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
}

example simpleNotValid is not ValidStates for {
    State = `S0
    Node = `N1 + `N2 + `N3
    l_child = `N1 -> `N2
    r_child = `N1 -> `N3
    elt = `N1 -> 4 + `N2 -> 0 + `N3 -> 0
    root = `S0 -> `N1

}

example leftSubTreeStillLower is ValidStates for {
    State = `S0
    Node = `N1 + `N2 + `N3 + `N4
    l_child = `N1 -> `N2
    r_child = `N1 -> `N3 + `N2 -> `N4
    elt = `N1 -> 4 + `N2 -> 0 + `N3 -> 5 + `N4 -> 2
    root = `S0 -> `N1
}

example noRightSubTreeFromRoot is ValidStates for {
    State = `S0
    Node = `N1 + `N2 + `N3 + `N4
    l_child = `N1 -> `N2
    r_child = `N2 -> `N4 + `N4 -> `N3
    elt = `N1 -> 4 + `N2 -> 0 + `N3 -> 3 + `N4 -> 2
    root = `S0 -> `N1
}

example subNodeNotGreater is not ValidStates for {
    State = `S0
    Node = `N1 + `N2 + `N3 + `N4
    l_child = `N1 -> `N2
    r_child = `N2 -> `N4 + `N4 -> `N3
    elt = `N1 -> 4 + `N2 -> 0 + `N3 -> 5 + `N4 -> 2
    root = `S0 -> `N1
}

example childNotParent is not ValidStates for {
    State = `S0
    Node = `N1 + `N2  + `N4
    l_child = `N1 -> `N2
    r_child = `N2 -> `N4 + `N4 -> `N2
    elt = `N1 -> 4 + `N2 -> 0 + `N4 -> 2
    root = `S0 -> `N1
}

example childNotRoot is not ValidStates for {
     State = `S0
    Node = `N1 + `N2 + `N3 + `N4
    l_child = `N1 -> `N2 
    r_child = `N2 -> `N4 + `N4 -> `N3 + `N3 -> `N1
    elt = `N1 -> 4 + `N2 -> 0 + `N3 -> 3 + `N4 -> 2
    root = `S0 -> `N1
}

example rootNoParents is not ValidStates for {
     State = `S0
    Node = `N1 + `N2 + `N3 + `N4
    l_child = `N1 -> `N2 
    r_child = `N2 -> `N4 + `N4 -> `N3 + `N3 -> `N1
    elt = `N1 -> 4 + `N2 -> 0 + `N3 -> 3 + `N4 -> 2
    root = `S0 -> `N2
}


test expect {
    noPredicate: {} is sat
    -- every node is less than/greater than root node in their respective spots
    rootMiddle: {
        ValidStates
        all n : Node | {
            reachable[n, State.root.l_child, l_child, r_child] => State.root.elt > n.elt
            reachable[n, State.root.r_child, l_child, r_child] => State.root.elt < n.elt
        }
        State.root.elt > State.root.l_child.elt
        State.root.elt < State.root.r_child.elt
    } is sat
    -- if we have node on left side, root must not be less than
    rootMiddleLessThan: {
        ValidStates
        all n : Node | {
            reachable[n, State.root.l_child, l_child, r_child]
            reachable[n, State.root.l_child, l_child, r_child] => State.root.elt < n.elt
        }
    } for exactly 3 Node is unsat
    -- all nodes must be in between its left and right subtrees.
    allNodesMiddle: {
        ValidStates
        all disj n1, n2 : Node | {
            reachable[n1, n2.l_child, l_child, r_child] => n2.elt > n1.elt
            reachable[n1, n2.r_child, l_child, r_child] => n2.elt < n1.elt
            some n2.l_child => n2.elt > n2.l_child.elt
            some n2.r_child => n2.elt < n2.r_child.elt
        }
    } for exactly 10 Node is sat
    -- no node must be greater than any node in its right subtree
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
    -- displays tree that only has left subtree to avoid being unsatisfiable
    unBalancedTreeLeft: {
        ValidStates
        all disj n1, n2 : Node | {
            reachable[n1, n2.l_child, l_child, r_child] => n2.elt > n1.elt
            reachable[n1, n2.r_child, l_child, r_child] => n2.elt > n1.elt
            some n2.l_child => n2.elt > n2.l_child.elt
            some n2.r_child => n2.elt > n2.r_child.elt
        }
    } for exactly 10 Node is sat
    -- left and right child if exists can not be same
    noSameChild: {
        ValidStates
        some n : Node {
            // if two child exist, can't be same
            some n.l_child
            some n.r_child
            (some n.l_child and some n.r_child) => n.l_child = n.r_child
        }
    } is unsat
    -- no node has same element.
    noSameEle: {
        ValidStates
        all disj n1, n2 : Node {
            n1.elt = n2.elt
        } 
    } for exactly 10 Node is unsat
    

}

run {
    ValidStates
} for exactly 5 Node
