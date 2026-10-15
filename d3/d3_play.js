(function() {

    /***********************************************************************************/
    /*                 Basic HTML Setup                                                */
    /*                                                                                 */
    /*                 3 sections/divs                                                 */
    /*                                                                                 */
    /*                 2 palettes (with buttons above)                                 */
    /*                 1 Graphic (with buttons above)                                  */
    /*                                                                                 */
    /***********************************************************************************/

    // specify width and heights of svgs
    const width =  window.innerWidth,
        height = 80,
        height1 = 600;

    // Page Title
    d3.select('body')
        .append('h1')
        .text('My d3.js Playground');

    // Create 3 Divs (1 for each section)
    // divs for the 3 sections of the page
    // div for first palette
    const colorPaletteDiv1 = d3.select('body')
         .append('div')
         .attr("id", "colorPaletteDiv1");

    // div for first palette
    const colorPaletteDiv2 = d3.select('body')
         .append('div')
         .attr("id", "colorPaletteDiv1");

    // div for first palette
    const colorGraphic = d3.select('body')
         .append('div')
         .attr("id", "colorGraphic");

    // svgs and divs for the 3 sections of the page
    // div for buttons
    const sequentialButtonDivs = colorPaletteDiv1
        .append('div')
        .attr("class", "sequentialButtons");

    // svg for color spectrum (continuous)
    const svg1 = colorPaletteDiv1
        .append("svg")
        .attr("width", width)
        .attr("height", height)
        .append("g")
        
    // div for bars
    svg1.select('svg')
        .append('div')
        .attr("class", "bars");

    // div for buttons
    const divergingButtonDivs = colorPaletteDiv2
        .append('div')
        .attr("class", "divergingButtons");

    // svg for color spectrum (continuous)
    const svg2 = colorPaletteDiv2
        .append("svg")
        .attr("width", width)
        .attr("height", height)
        .append("g")
        
    // div for bars
    svg2.select('svg')
        .append('div')
        .attr("class", "barsDiverging");

    // Buttons for circles
    const circleButtonDivs = colorGraphic
        .append('div')
        .attr("id", "circleButtonDiv");

    // svg for color spectrum (continuous)
    const svg3 = colorGraphic
        .append("svg")
        .attr("width", width)
        .attr("height", height1)
        .append("g")


    /***************************/
    
    
    // Create datasets
    const dataset = d3.range(0, 1, 0.025);
    const dataset1 = Array.from({length: 10000}, () => Math.floor(Math.random() * 600));

    console.log(dataset1.length)

    // Create color categories - array of objects
    const sequential = [{
            "name": "interpolateViridis"
        },
        {
            "name": "interpolateInferno"
        },
        {
            "name": "interpolateMagma"
        },
        {
            "name": "interpolatePlasma"
        },
        {
            "name": "interpolateWarm"
        },
        {
            "name": "interpolateCool"
        },
        {
            "name": "interpolateCubehelixDefault"
        },
        {
            "name": "interpolateRainbow"
        },
        {
            "name": "interpolateSinebow"
        }
    ]

    const diverging = [{
            "name": "interpolateRdYlBu"
        },
        {
            "name": "interpolateBrBG"
        },
        {
            "name": "interpolatePRGn"
        },
        {
            "name": "interpolatePiYG"
        },
        {
            "name": "interpolatePiYG"
        },
        {
            "name": "interpolateRdBu"
        },
        {
            "name": "interpolateRdGy"
        },
        {
            "name": "interpolateRdGy"
        },
        {
            "name": "interpolateSpectral"
        }
    ]

//     const myColorsCat = [{
//             "category10": d3.schemeCategory10
//         }, //An array of ten categorical colors represented as RGB hexadecimal strings.
//         {
//             "Accent": d3.schemeAccent
//         }, //An array of eight categorical colors represented as RGB hexadecimal strings.
//         {
//             "Dark2": d3.schemeDark2
//         }, //An array of eight categorical colors represented as RGB hexadecimal strings.
//         {
//             "Paired": d3.schemePaired
//         }, //An array of twelve categorical colors represented as RGB hexadecimal strings.
//         {
//             "Pastel1": d3.schemePastel1
//         }, //An array of nine categorical colors represented as RGB hexadecimal strings.
//         {
//             "Pastel2": d3.schemePastel2
//         }, //An array of eight categorical colors represented as RGB hexadecimal strings.
//         {
//             "Set1": d3.schemeSet1
//         }, //An array of nine categorical colors represented as RGB hexadecimal strings.
//         {
//             "Set2": d3.schemeSet2
//         }, //An array of eight categorical colors represented as RGB hexadecimal strings.
//         {
//             "Set3": d3.schemeSet3
//         }, //An array of twelve categorical colors represented as RGB hexadecimal strings.
//         {
//             "Tableau10": d3.schemeTableau10
//         }
//     ] //An array of ten categorical colors authored by Tableau as part of Tableau 10 represented as RGB hexadecimal strings.

    // Create color categories - An object
        const myColors = {
                "BrBG": d3.schemeBrBG,
                //Given a number t in the range [0,1], returns the corresponding color from the “BrBG” diverging color scheme represented as an RGB string."
                "PRGn": d3.schemePRGn,
                //Given a number t in the range [0,1], returns the corresponding color from the “PRGn” diverging color scheme represented as an RGB string."
                "PiYG": d3.schemePiYG,
                //Given a number t in the range [0,1], returns the corresponding color from the “PiYG” diverging color scheme represented as an RGB string."
                "PuOr": d3.schemePuOr,
                //Given a number t in the range [0,1], returns the corresponding color from the “PuOr” diverging color scheme represented as an RGB string."
                "RdBu": d3.schemeRdBu,
                //Given a number t in the range [0,1], returns the corresponding color from the “RdBu” diverging color scheme represented as an RGB string."
                "RdGy": d3.schemeRdGy,
                //Given a number t in the range [0,1], returns the corresponding color from the “RdGy” diverging color scheme represented as an RGB string."
                "RdYlBu": d3.schemeRdYlBu,
                //Given a number t in the range [0,1], returns the corresponding color from the “RdYlBu” diverging color scheme represented as an RGB string."
                "RdYlGn": d3.schemeRdYlGn,
                //Given a number t in the range [0,1], returns the corresponding color from the “RdYlGn” diverging color scheme represented as an RGB string."
                "Spectral": d3.schemeSpectral
            }
            //Given a number t in the range [0,1], returns the corresponding color from the “Spectral” diverging color scheme represented as an RGB string.

// 
//         const myColors = [{
//                 "BrBG": d3.schemeBrBG
//             },
//             //Given a number t in the range [0,1], returns the corresponding color from the “BrBG” diverging color scheme represented as an RGB string."
//             {
//                 "PRGn": d3.schemePRGn
//             },
//             //Given a number t in the range [0,1], returns the corresponding color from the “PRGn” diverging color scheme represented as an RGB string."
//             {
//                 "PiYG": d3.schemePiYG
//             },
//             //Given a number t in the range [0,1], returns the corresponding color from the “PiYG” diverging color scheme represented as an RGB string."
//             {
//                 "PuOr": d3.schemePuOr
//             },
//             //Given a number t in the range [0,1], returns the corresponding color from the “PuOr” diverging color scheme represented as an RGB string."
//             {
//                 "RdBu": d3.schemeRdBu
//             },
//             //Given a number t in the range [0,1], returns the corresponding color from the “RdBu” diverging color scheme represented as an RGB string."
//             {
//                 "RdGy": d3.schemeRdGy
//             },
//             //Given a number t in the range [0,1], returns the corresponding color from the “RdGy” diverging color scheme represented as an RGB string."
//             {
//                 "RdYlBu": d3.schemeRdYlBu
//             },
//             //Given a number t in the range [0,1], returns the corresponding color from the “RdYlBu” diverging color scheme represented as an RGB string."
//             {
//                 "RdYlGn": d3.schemeRdYlGn
//             },
//             //Given a number t in the range [0,1], returns the corresponding color from the “RdYlGn” diverging color scheme represented as an RGB string."
//             {
//                 "Spectral": d3.schemeSpectral
//             }
//             //Given a number t in the range [0,1], returns the corresponding color from the “Spectral” diverging color scheme represented as an RGB string.
//         ]
    const myColorsCat = {
        "category10": d3.schemeCategory10, //An array of ten categorical colors represented as RGB hexadecimal strings.

        "Accent": d3.schemeAccent, //An array of eight categorical colors represented as RGB hexadecimal strings.

        "Dark2": d3.schemeDark2, //An array of eight categorical colors represented as RGB hexadecimal strings.

        "Paired": d3.schemePaired, //An array of twelve categorical colors represented as RGB hexadecimal strings.

        "Pastel1": d3.schemePastel1, //An array of nine categorical colors represented as RGB hexadecimal strings.

        "Pastel2": d3.schemePastel2, //An array of eight categorical colors represented as RGB hexadecimal strings.

        "Set1": d3.schemeSet1, //An array of nine categorical colors represented as RGB hexadecimal strings.

        "Set2": d3.schemeSet2, //An array of eight categorical colors represented as RGB hexadecimal strings.

        "Set3": d3.schemeSet3, //An array of twelve categorical colors represented as RGB hexadecimal strings.

        "Tableau10": d3.schemeTableau10
    } //An object of ten categorical colors authored by Tableau as part of Tableau 10 represented as RGB hexadecimal strings.
    // 
    //     
    //     console.log("Random Color");
    //     console.log(randomColor);
    //     console.log(Object.values(randomColor)[0]);
    //     console.log(Object.values(myColors[0])[0])

    // Create 3 Divs (1 for each section)

    /***************************/
    


    // Continuous Color (for bars)
    const unit = (s) => width / s.n;
    const state = {
        n: 12,
        colorScale: d3.scaleSequential(d3[sequential[8].name])
    };

    // Diverging Color (for bars)
    const unitDiverging = (s) => width / s.n;
    const stateDiverging = {
        n: 12,
        colorScale: d3.scaleSequential(d3[diverging[8].name])
    };


    console.log(state.colorScale);
    
    
    // Integer list (for discrete color)
    var color_data = d3.range(dataset.length);
    // Discrete Color Function (accessed using color(n))
    var colors = d3.scaleQuantize()
        .domain([Math.min(...color_data), Math.max(...color_data)])
        .range(["#5E4FA2", "#3288BD", "#66C2A5", "#ABDDA4", "#E6F598",
            "#FFFFBF", "#FEE08B", "#FDAE61", "#F46D43", "#D53E4F", "#9E0142"
        ]);

    var myColor = d3.scaleOrdinal()
        .domain(dataset)
        .range(d3.schemeDark2);
    //           .range(d3.schemeSet3);

    //     var myColor_random = d3.scaleOrdinal()
    //         .domain(dataset)
    //         .range(Object.values(myColors[0])[0]);

    //     var myColor_random = d3.scaleOrdinal()
    //         .domain(dataset)
    //         .range(Object.values(randomColor)[0]);

    function myColorFunction(x) {
        var myColor_random = d3.scaleOrdinal()
            .domain(dataset)
            .range(x);
        return myColor_random; // The function returns the product of p1 and p2
    }

    //     console.log(dataset.length);
    //     console.log(color_data);
    //     console.log([Math.min(...color_data), Math.max(...color_data)]);
    //     console.log(colors);
    //     console.log("colors(0.5)");
    //     console.log(colors(0.5));
    //     console.log("myColor_random(0.5)");
    //     console.log(myColor_random(0.5));





    /***************************/
    


    // Adding simple text - then coloring it.
    d3.select('body')
        .selectAll('p')
        .data(dataset)
        .enter()
        .append('p')
        .text('Hello There New')
        .style("color", (d, i) => colors(i));


    /****************************************/
    /*       Color Sequential Bars          */
    /****************************************/

    // Create Colored Bars
    const update = () => {

        bars.data(d3.range(0, 1, 1 / state.n))
            .enter().append("rect")
            .attr("class", "bars")
            .attr("y", 0)
            .attr("height", height)
            .attr("width", unit(state))
            .attr("x", (d, i) => i * unit(state))
            .style("fill", state.colorScale)
            .merge(bars);

        bars.exit().remove();

    }

    const bars = svg1.selectAll(".bars");

    update()

    // Create Color Buttons
    const sequentialButtons = sequentialButtonDivs
        .selectAll("button")
        .data(sequential)
        .enter()
        .append("button")
        .text(d => d.name)
        .on("click", (buttonValue) => {
            state.colorScale = d3.scaleSequential(d3[buttonValue.name]);
            update();
        });

    const itemsInput = d3.select('#items')
        .on('change', (d, i, arr) => {
            state.n = arr[i].value;
            update();
        });

    /****************************************/
    /*       Color Diverging Bars           */
    /****************************************/


    // Create Colored Bars
    const updateDiverging = () => {

        barsDiverging.data(d3.range(0, 1, 1 / stateDiverging.n))
            .enter().append("rect")
            .attr("class", "barsDiverging")
            .attr("y", 0)
            .attr("height", height)
            .attr("width", unitDiverging(stateDiverging))
            .attr("x", (d, i) => i * unit(stateDiverging))
            .style("fill", stateDiverging.colorScale)
            .merge(bars);

        barsDiverging.exit().remove();

    }

    const barsDiverging = svg2.selectAll(".barsDiverging");

    updateDiverging()

    // Create Color Buttons
    const divergingButtons = divergingButtonDivs
        .selectAll("button")
        .data(diverging)
        .enter()
        .append("button")
        .text(d => d.name)
        .on("click", (buttonValue) => {
            stateDiverging.colorScale = d3.scaleSequential(d3[buttonValue.name]);
            updateDiverging();
        });

    const itemsInputDiverging = d3.select('#itemsDiverging')
        .on('change', (d, i, arr) => {
            stateDiverging.n = arr[i].value;
            updateDiverging();
        });

    /****************************************/
    /*               Color Circles             */
    /****************************************/


    d3.select('#circleButtonDiv')
        .selectAll('div')
        .data(Object.keys(myColors))
        .enter()
        .append('div')
        .attr("class", "circleButtons");


    // How to access keys and values from the color dictionary
    console.log("myColorsCat")
    console.log(Object.keys(myColors))
    console.log(Object.values(myColors))
    console.log(myColorsCat["Dark2"])

    var baseColorScale = myColors["RdYlBu"];
    var buttonValueNew = "RdYlBu";
    console.log("baseColorScale")
    console.log(baseColorScale)
    
//     Select a palette at random
//     var randomColor = myColors[Math.floor(Math.random() * myColors.length)];

    // Create Colored Circles
    const update_circles = () => {

        //         var currentColor = Object.values(myColors[i % 8])[0]
        console.log(buttonValueNew)
        var classValue = "circleChart" + "_" + buttonValueNew;
        
// 
        svg3.append("text")
            .attr("x", 0)
            .attr("y", 0)
            .attr("dy", "4em")
            .text(buttonValueNew)
            .style('fill', baseColorScale[8][Math.round(Math.random() * 7) % 8])
            .style("font-size", 100)
            .style("opacity", 1)
            .transition()
            .duration(5000)
            .ease(d3.easeLinear)
            .style("opacity", 0)
            .attr("fake", console.log(baseColorScale[8][Math.round(Math.random() * 7) % 8]));

        circles
            .data(dataset1)
            .enter()
            .append("circle")
            .attr("class", classValue)
            .transition()
            .attr("r", (d, i) => Math.random() * 7)
            .attr("cx", (d, i) => Math.random() * (i % width))
            .attr("cy", (d, i) => Math.random() * (i % 600))
            //                 .style("fill", (d, i) => color(i))
            .style("fill", (d, i) => baseColorScale[8][i % 8])
            .delay(function(d,i){return(i*3)})
            .duration(2500)
            .ease(d3.easeBounce)
//             .attr("fake", (d, i) => console.log(baseColorScale[i % 8]))
//             .attr("fake2", (d, i) => console.log(i))
        //                 .merge(circles);
//         circles.remove();
        svg3.selectAll("." + classValue)
            .transition()
            .delay(15000)
            .duration(5000)
            .remove()


    }

    const circlesButtons = circleButtonDivs.select(".circleButtons")
        .selectAll("button")
        .data(Object.keys(myColors))
        .enter()
        .append("button")
        .text(d => d)
        .on("click", (buttonValue) => {
            baseColorScale = myColors[buttonValue];
            buttonValueNew = buttonValue;
            console.log(buttonValue);
            update_circles();
        });
        
    const circles = svg3.selectAll("circle")
    update_circles();
    //     
    // 
    // 
    // 
    //     for (var ind = 0; ind < 1000; ind++) {
    //         if (ind % 100 === 0) {
    //             var randomColor = myColors[Math.floor(Math.random() * myColors.length)];
    //         }
    //         // 
    //         //         console.log(randomColor)
    //         //         console.log(ind)
    //         //         console.log(ind % 100 === 0)
    // 
    //         setTimeout(() => {
    //                 // Select a palette at random
    //                 update_circles(ind);
    //             },
    //             200 * ind);
    //     }
})();