const d3 = require('d3')
let num_states = 0;
let num_nodes = 0;
let depth = 0;
d3.selectAll("svg > *").remove();

function max_depth(state) {
    depth = recur_max_depth(state.root) + 1; //Includes bottom leaf
}

function recur_max_depth(current_node) {
    if (current_node.elt.toString() == "") return 0;
    let l_tree = recur_max_depth(current_node.l_child);
    let r_tree = recur_max_depth(current_node.r_child);
    return 1 + Math.max(l_tree, r_tree);
}

function countNumNodes(state) {
    num_nodes = recurCountNodes(state.root);
}

function recurCountNodes(current_node) {
    if (current_node.elt.toString() != "") {
        return recurCountNodes(current_node.l_child) +
            recurCountNodes(current_node.r_child) +
            1;
    } else return 0;
}

function countStates() {
    while (State.atom("State"+num_states) != null) {
        num_states += 1;
    }
}

function printNode(row, col, yoffset, distance, value) {
    let cx = (row+1)*25;
    let cy = (col+1)*15 + yoffset;
    let x2_left = ((row - (distance/2.0))+1)*25;
    let x2_right = ((row + (distance/2.0))+1)*25;
    let y2 = ((col+1)+1)*15 + yoffset+30;
    let r = 15;
    d3.select(svg)
        .append("line")
        .style("stroke", "black")
        .attr("x1", cx)
        .attr("y1", cy)
        .attr("x2", x2_left)
        .attr("y2", y2);
    d3.select(svg)
        .append("line")
        .style("stroke", "black")
        .attr("x1", cx)
        .attr("y1", cy)
        .attr("x2", x2_right)
        .attr("y2", y2);
    d3.select(svg)
        .append("circle")
        .style("fill", "white")
        .attr("cx", cx)
        .attr("cy", cy)
        .attr("r", r)
        .attr("stroke", "black");
    d3.select(svg)
        .append("text")
        .style("fill", "black")
        .attr("x", (cx-(r/2)+4))
        .attr("y", (cy+(r/2)-2))
        .text(value);
}

function printLeaf(row, col, yoffset) {
    let cx = (row+1)*25;
    let cy = (col+1)*15 + yoffset;
    let r = 5;
    d3.select(svg)
        .append("circle")
        .style("fill", "black")
        .attr("cx", cx)
        .attr("cy", cy)
        .attr("r", r);
}

function printState(currentNode, yoffset, row, col, distance) {
    if (currentNode.elt.toString() != "") {
        printNode(row, col, yoffset, distance, currentNode.elt.toString());
        printState(currentNode.l_child, yoffset+30, row - (distance/2.0), col+1, distance/2.0);
        printState(currentNode.r_child, yoffset+30, row + (distance/2.0), col+1, distance/2.0);
    } else {
        printLeaf(row, col, yoffset);
    }
}


var offset = 5
countStates();
for(b = 0; b < num_states; b++) {  
    if(State.atom("State"+b) != null) {
        let state = State.atom("State"+b);
        countNumNodes(state);
        max_depth(state);
        printState(state.root, offset, num_nodes/2.0, 0, num_nodes/2.0);
    }  
    
    offset = offset + depth*45 + 10;
    d3.select(svg)
        .style("stroke", "black")
        .append("line")
        .attr("x1", 0)
        .attr("y1", offset - 10)
        .attr("x2", 500)
        .attr("y2", offset - 10)
        .attr("stroke-dasharray",5,5);
    
}
