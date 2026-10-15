(function() {
    // Create dataset
    const dataset = d3.range(0, 1, 0.025);
    const dataset1 = d3.range(0, 600, 25);

    // specify width and heights of svgs
    const width = 600,
        height = 80,
        height1 = 600;

    // Page Title
    d3.select('body')
        .append('h1')
        .text('My d3.js Playground');

    // svg for color spectrum (continuous)
    const svg = d3.select("body")
        .append("svg")
        .attr("width", width)
        .attr("height", height1)
        .append("g")
        .attr("id", "firstGroup")
        
    const rect = svg
       .append('rect')
        .attr("width", "100%")
        .attr("height", "100%")
        .attr("fill", "yellow")
    
    const innerRect = svg
        .append('rect')
        .attr("width", "40%")
        .attr("height", "40%")
        .attr("fill", "green")
        .append("g")
        .attr("id", "innerRectGroup")


    const circle1 = svg
       .append('circle')
       .attr("r", "100")
        .attr("cx", "400")
        .attr("cy", "400")
        .attr("fill", "red")
    
    const svg1 = d3.select("body")
        .append("svg")
        .attr("width", width)
        .attr("height", height1)
        .append("g")
        .attr("id", "secondGroup")

    const rect1 = svg1
       .append('rect')
        .attr("width", "100%")
        .attr("height", "100%")
        .attr("fill", "yellow")
    
    const circle11 = svg1
       .append('circle')
       .attr("r", "100")
        .attr("cx", "400")
        .attr("cy", "400")
        .attr("fill", "red")
 
//      svg1
//         .attr("x","100")
//     var rotateTranslate = d3.svg.transform().rotate(-45).translate(200, 100);
    
    d3.select("#secondGroup")
        .attr('transform', 'translate(100,0)rotate(-45)')
        
//     d3.select("#secondGroup")
//         .attr("transform","rotate(45 50 50)")

    // div for buttons
    const sequentialButtonDivs = d3.select('body').append('div').attr("id", "sequentialButtonsDiv");
    d3.select('#sequentialButtonsDiv')
        .selectAll('div')
        .data(dataset)
        .enter()
        .append('div')
        .attr("class", "sequentialButtons");

    // div for bars
    svg.select('svg')
        .append('div')
        .attr("class", "bars");

    // Adding simple text - then coloring it.
    d3.select('body')
        .selectAll('p')
        .data(dataset)
        .enter()
        .append('p')
        .text('Hello There New')
//         .style("color", (d, i) => colors(i));

    /****************************************/
    /*               Color Sequential Bars             */
    /****************************************/

    // Create Colored Bars
//     const update = () => {
// 
//         bars.data(d3.range(0, 1, 1 / state.n))
//             .enter().append("rect")
//             .attr("class", "bars")
//             .attr("y", 0)
//             .attr("height", height)
//             .attr("width", unit(state))
//             .attr("x", (d, i) => i * unit(state))
//             .style("fill", state.colorScale)
//             .merge(bars);
// 
//         bars.exit().remove();
// 
//     }
// 
//     const bars = svg.selectAll(".bars");
// 
//     update()
// 
//     // Create Color Buttons
//     const sequentialButtons = sequentialButtonDivs.select(".sequentialButtons")
//         .selectAll("button")
//         .data(sequential)
//         .enter()
//         .append("button")
//         .text(d => d.name)
//         .on("click", (buttonValue) => {
//             state.colorScale = d3.scaleSequential(d3[buttonValue.name]);
//             update();
//         });
// 
//     const itemsInput = d3.select('#items')
//         .on('change', (d, i, arr) => {
//             state.n = arr[i].value;
//             update();
//         });
// 
//     /****************************************/
//     /*               Color Diverging Bars             */
//     /****************************************/
// 
//     // Create Colored Bars
//     const updateDiverging = () => {
// 
//         barsDiverging.data(d3.range(0, 1, 1 / stateDiverging.n))
//             .enter().append("rect")
//             .attr("class", "barsDiverging")
//             .attr("y", 0)
//             .attr("height", height)
//             .attr("width", unitDiverging(stateDiverging))
//             .attr("x", (d, i) => i * unit(stateDiverging))
//             .style("fill", stateDiverging.colorScale)
//             .merge(bars);
// 
//         barsDiverging.exit().remove();
// 
//     }
// 
//     const barsDiverging = svg2.selectAll(".barsDiverging");
// 
//     updateDiverging()
// 
//     // Create Color Buttons
//     const divergingButtons = divergingButtonDivs.select(".divergingButtons")
//         .selectAll("button")
//         .data(diverging)
//         .enter()
//         .append("button")
//         .text(d => d.name)
//         .on("click", (buttonValue) => {
//             stateDiverging.colorScale = d3.scaleSequential(d3[buttonValue.name]);
//             updateDiverging();
//         });
// 
//     const itemsInputDiverging = d3.select('#itemsDiverging')
//         .on('change', (d, i, arr) => {
//             stateDiverging.n = arr[i].value;
//             updateDiverging();
//         });
//     /****************************************/
//     /*               Color Circles             */
//     /****************************************/
// 
//     // Create Colored Circles
//     const update_circles = () => {
// 
//         circles
//             .data(dataset)
//             .enter()
//             .append("circle")
//             .attr("class", "circleChart")
//             .transition()
//             .delay(2000)
//             .duration(2000)
//             .attr("r", (d, i) => Math.random() * 7)
//             .attr("cx", (d, i) => Math.random() * 72 * i)
//             .attr("cy", (d, i) => Math.random() * 72 * i)
//             //                 .style("fill", (d, i) => color(i))
//             .style("fill", (d, i) => myColor_random(d))
//         //                 .merge(circles);
// 
//         circles.exit().remove();
// 
//     }
// 
//     console.log(d3.range(0, 1, 1 / state.n))
//     const circles = svg1.selectAll("circle")
// 
// 
// 
//     for (var ind = 0; ind < 1000; ind++) {
// 
//         setTimeout(() => {
//                 update_circles();
//             },
//             200 * ind);
//     }
})();