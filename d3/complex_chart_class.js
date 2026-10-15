class barChart {
    constructor() {
        this.margin = ({
            top: 20,
            right: 20,
            bottom: 30,
            left: 50
        });
        this.width = window.innerWidth / 1.25;
        this.height = window.innerHeight / 1.25;

        // Set HTML page dimensions
        const viewportWidth = Math.max(
            document.documentElement.clientWidth,
            window.innerWidth
        );
        const viewportHeight = Math.max(
            document.documentElement.clientHeight,
            window.innerHeight
        );

        if (viewportWidth <= 768) {
            this.width = viewportWidth - this.margin.left - this.margin.right; // Use the window's width
            this.height = 0.5 * viewportHeight - this.margin.top - this.margin.bottom; // Use the window's height
        } else {
            this.width = 0.75 * viewportWidth - this.margin.left - this.margin.right;
            this.height = viewportHeight - this.margin.top - this.margin.bottom; // Use the window's height
        }

        this.xDomain;
        this.xScale;
        this.yscale;
        this.tcBlack = "#130C0E";
        this.tcBlack = "red";
        this.t = d3.transition()
            .duration(1750);

        this.weekday_order = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'];
        
        var i = 0
        this.weekday_order_dict = this.weekday_order.forEach(d => {d:i}, i++)
        this.month_order = ['January', 'February', 'March', 'April', 'May', 'June',
            'July', 'August', 'September', 'October', 'November', 'December'
        ];
        this.hist = true;

        // load data - once data is loaded initialize chart
        this.loadData().then(data => {
            this.initialiseChart(data);
        });

    }

    // Add line breaks for axes and tick labels
    insertLinebreaks(d) {
        if (typeof d === 'string') {
            var el = d3.select(this);
            var words = d.split(/[\s\/]+/);
            el.text('');

            for (var i = 0; i < words.length; i++) {
                var tspan = el.append('tspan').text(words[i]);
                if (i > 0)
                    tspan.attr('x', 0).attr('dy', '10');
            }
        }
    }

    titleCase(str) {
        return str.toLowerCase().split(' ').map(function(word) {
            return word.replace(word[0], word[0].toUpperCase());
        }).join(' ');
    }

    loadData() {
        let loadFile = '2017macrash_I90_subset_mine.txt';

        return d3.csv(loadFile).then(data => {

            function formatTime(date) { // This is to display 24 hour format
                var hours = date.getHours();
                var minutes = date.getMinutes();
                var strTime = hours + ':' + minutes;
                return strTime;
            }
            var formatMonth = d3.timeFormat("%B"),
                formatDay = d3.timeFormat("%A");

            var variable_names = ['Age', 'Light Condition', 'Average Daily % Combo Trucks-Linked Rd',
                'County Name', 'Crash Datetime', 'Driver Age',
                'Federal Aid Route Number-Linked Rd', 'Hit And Run', 'Injury Type',
                'Total Fatal Injuries', 'Total Nonfatal Injuries', 'Number Of Vehicles',
                'Road Surface Condition', 'School Bus Related', 'Sex',
                'Speed Limit-Linked Rd', 'Speed Limit', 'Surface Width-Linked Rd',
                'Transported By', 'Vehc Unit Numb', 'Weather Condition'
            ]

            // Set types and create variables
            data.forEach(d => {
                // convert the string to a time variable
                d.date = new Date(d['Crash Datetime']);
                // extract other useful information
                d.day = String(d.date.getDay()); //returns 0 - 6
                d["Day of Week"] = formatDay(d.date);
                d.month = formatMonth(d.date); //returns 0 - 11
                d.year = d.date.getFullYear();
                d.time = formatTime(d.date);
                d['Average Daily % Combo Trucks-Linked Rd'] = +d['Average Daily % Combo Trucks-Linked Rd'];
                d["Speed Limit"] = +d["Speed Limit"];
                //                 d['Total Fatal Injuries'] = +d['Total Fatal Injuries'];
                d['Total Nonfatal Injuries'] === "18" ? d['Total Nonfatal Injuries'] = "Eighteen" : d['Total Nonfatal Injuries'] = d['Total Nonfatal Injuries'];
                d['Average Daily % Combo Trucks-Linked Rd'] = +d['Average Daily % Combo Trucks-Linked Rd'];
                d.Age = +d.Age;
                if (d.Sex === "" || d.Sex === "Not reported") {
                    d.Sex = "Unknown"
                };
            });

            /********************************************************************/
            /*                  New Drop Down                                   */
            /*                                                                  */
            /*                  Select Graph Type                               */
            /*                  Which filters the variable drop down            */
            /********************************************************************/

            // Create List of Numeric and Non-numeric data
            function isNumeric(num) {
                return !isNaN(num)
            }
            var dropdownData = [];
            d3.keys(data[0]).forEach(d => {
                if (isNumeric(data[0][d])) {
                    dropdownData.push({
                        "Type": "Histogram",
                        "Variable": d
                    });
                    dropdownData.push({
                        "Type": "Graphs",
                        "Variable": d
                    });
                } else {
                    dropdownData.push({
                        "Type": "Histogram",
                        "Variable": d
                    });
                    dropdownData.push({
                        "Type": "Group",
                        "Variable": d
                    });
                };

            })

            console.log("dropdownData: ", dropdownData[0])


            // Nest the data by Graph Type and variable
            var nested = d3.nest()
                .key(function(d) {
                    return d.Type;
                })
                .key(function(d) {
                    return d.Variable;
                })
                .entries(dropdownData);

            console.log("nested: ", nested);
            console.log("nested.map(d => d.key): ", nested.map(d => d.key));

            // Set up data selection box for Graphs
            var select1 = d3.select("#selector")
                .append("div")
                .append("select")
                .attr("class", "select")
                .attr("id", "select1")
                .on("change", function() {

                    // Change the selection box for group2, dependent on the group1 selection
                    var g = this.value;
                    var filtered = nested.filter(d => d.key === g);


                    var options2 = d3.select("#select2").selectAll("option")
                        .data(filtered[0].values.map(d => d.key));

                    options2.exit().remove();

                    options2.enter()
                        .append("option")
                        .merge(options2)
                        .text(d => d);

                });

            // Options for Graphs selection menu
            var options1 = d3.select("#select1")
                .selectAll("option")
                .data(nested.map(d => d.key))
                .enter()
                .append('option')
                .text(d => d);

            // Setup initial selection box for Histograms
            var select2 = d3.select("#selector")
                .append("div")
                .append("select")
                .attr("class", "select")
                .attr("id", "select2")
                .on("change", onchange);

            // Initial options for Histograms selection menu
            var filtered = nested.filter(function(d) {
                return d.key == "Histogram";
            });
            var options2 = d3.select("#select2")
                .selectAll("option")
                .data(filtered[0].values.map(d => d.key))
                .enter()
                .append("option")
                .text(d => d);

            var that = this;
            var setDataset = this.setDataset

            function onchange() {
                console.log(event.target.value)
                var sel1 = d3.select("#select1").property("value");
                var sel2 = d3.select("#select2").property("value");
                console.log(sel1)
                console.log(sel2)
                if (sel1 === "Graphs") {
                    that.setGraph(sel2);
                    console.log("Graph")
                } else if (sel1 === "Histogram") {
                    that.setDataset(sel2);
                    console.log("Histogram")
                } else {
                    that.group(sel2);
                    console.log("Group")
                }
                console.log("Current selection: ", sel1 + ", " + sel2);
            }
            return data;
        });
    }

    toggleCheckBox() {
        this.hist = this.hist === true ? false : true;
        console.log(this.hist)
    }

    // Group data by 
    group(variable) {
        console.log("variable: ", variable)
        
        this.variableUnique = [...new Set(this.data.map(d => d[variable]))]
        console.log("this.variableUnique: ", this.variableUnique)
        
        
        this.variable = variable;

        var data_nest = d3.nest()
            .key(d => d["Day of Week"])
            .key(d => d[this.variable])
            //     	.rollup(function(v) { return d3.sum(v, function(d) { return d.price; }); })
            .entries(this.data);

        console.log("data_nest: ", data_nest)

        var data_stack = []
        
        var that=this;
        data_nest.forEach(function(d, i) {
            var t = {}
            t['day'] = d.key
            d.values.forEach(e => e.values.length != 0 ? t[e.key] = e.values.length: t[e.key] = 0)
            that.variableUnique.forEach(f => f in t ? null: t[f] = 0)
            data_stack.push(t)
        })
        console.log("data_stack ", data_stack)
        
        // Sort by reference order (i.e. sort array by day)
        var reference_arr = this.weekday_order;
        data_stack.sort(function(a, b) {
                    return reference_arr.indexOf(a.day) - reference_arr.indexOf(b.day);
                });

        console.log("data_stack ", data_stack)
        
        
        var days = data_stack.map(d => d.day);
        
        console.log("days ", days)
        console.log("data_stack[0]", Object.keys(data_stack[0]).slice(1))
        



        var series = d3.stack()
                        .keys(Object.keys(data_stack[0]).slice(1))
                        .order(d3.stackOrderNone)
                        .offset(d3.stackOffsetNone)
                        (data_stack)
        

        console.log("series: ", series)

        d3.select('#chartSVG').remove()

        const gSvg = d3.select('#chart')
            .append('svg')
            .attr('id', 'chartSVG')
            .attr('width', this.width + this.margin['left'] + this.margin['right'])
            .attr('height', this.height + this.margin['top'] + this.margin['bottom'])
            .append('g')

        this.xScale = d3.scaleBand()
            .domain(days)
            .range([this.margin.left, this.width - this.margin.right])
            .padding(0.1);

        this.yScale = d3.scaleLinear()
            .domain([0, d3.max(series, d => d3.max(d, d => d[1]))])
            .range([this.height - this.margin.bottom, this.margin.top]);

        const color = d3.scaleOrdinal(d3.schemeCategory10);

        const rects = gSvg.selectAll("g")
            .data(series)
            .enter()
            .append("g")
            .attr("fill", d => color(d.key)) //Color is assigned here because you want everyone for the series to be the same color
            .attr("fake", d => console.log(color(d.key)))

        rects.selectAll("rect")
            .data(d => d)
            .attr("fake", d => console.log(d))
            .join("rect")
            .attr("x", (d, i) => this.xScale(d.data.day))
            .attr("y", d => this.yScale(d[1]))
            .attr("height", d => this.yScale(d[0]) - this.yScale(d[1]))
            .attr("width", this.xScale.bandwidth())
            .attr("fake", d => console.log(d))
        /*.on("mouseover", function(){d3.select(this).attr("fill", "purple")})
        .on("mouseout", function(){d3.select(this).attr("fill", color(series.key))})*/
        ;

        const xAxis = gSvg.append("g")
            .attr("id", "xAxis")
            .attr("transform", `translate(0,${this.height - this.margin.bottom})`)
            .call(d3.axisBottom(this.xScale))
            .call(g => g.append("text")
                .attr("x", this.width - this.margin.right)
                .attr("y", +30)
                .attr("fill", "currentColor")
                .attr("font-weight", "bold")
                .attr("text-anchor", "end")
                .text(this.variable)
                .attr("id", "xCurrentText"));

        const yAxis = gSvg.append("g")
            .attr("id", "yAxis")
            .attr("transform", `translate(${this.margin.left},0)`)
            .call(d3.axisLeft(this.yScale).ticks(this.height / 40))
            .call(g => g.select(".domain").remove())
            .call(g => g.select(".tick:last-of-type text").clone()
                .attr("x", 4)
                .attr("text-anchor", "start")
                .attr("font-weight", "bold")
                .text("Count")
                .attr("id", "yCurrentText"));
            
        var legendCount = days.length;

        var legendWidth = 10;
        var legendSpacing = 6;

        var legend = d3.select("#chartSVG").selectAll("g.legendg")
            .data(this.variableUnique)
            .enter().append("g")
            .attr('class', 'legendg')
            .attr("transform", "translate(" + (this.width - 200) + "," + 20 + ")");

        legend.append("rect")
            .attr("x", 45)
            .attr("y", (d, i) => i * 15)
            .attr("width", legendWidth)
            .attr("height", legendWidth)
            .attr("class", "legend")
            .style('fill', d => color(d));

        legend.append("text")
            .attr("x", (d, i) => 60)
            .attr("y", (d, i) => i * 15 + 5)
            .attr("dy", ".35em")
            .style("text-anchor", "start")
            .text(d => d)
            .attr('fill', d => color(d));




        //         To group the data by category:
        //         grpDataby_var = d3.group(this.data, d => d[variable])
        //         console.log("grpDataby_var: ", grpDataby_var)
        // 
        //         d3.groups (plural) returns a nested array
        //         grpSDataby_var = d3.groups(this.data, d => d[variable])
        //         console.log("grpSDataby_var: ", grpSDataby_var)
        // 
        //         To access category data - say the first
        //         grpDataby_var_cat = grpDataby_var.get(this.groupCategories[0])
        //         console.log("grpDataby_var_cat: ", grpDataby_var_cat)
        // 
        //         d3.rollup lets you “reduce” each group by computing a corresponding summary value, such as a sum or count. 
        //         grpDataby_count = d3.rollup(this.data, v => v.length, d => d[variable])
        //         console.log("grpDataby_count: ", grpDataby_count)
    }


    // Create Bins for Histograms - depending on whether the data is discrete or continuous
    binCreator() {
        // If the data is discrete 
        // Discrete Data
        if (this.discreteFlag) {
            //             console.log("values are discrete")

            //             console.log("this.variable: binCreator: ", this.variable)

            // Sort the data array, so the bins will be sorted
            if (this.variable === "Day of Week") {
                var reference_array = this.weekday_order;
                this.currentData.sort(function(a, b) {
                    return reference_array.indexOf(a) - reference_array.indexOf(b);
                });
            } else if (this.variable === "month") {
                var reference_array = this.month_order;
                this.currentData.sort(function(a, b) {
                    return reference_array.indexOf(a) - reference_array.indexOf(b);
                });
            } else {
                this.currentData.sort();
            }

            // Array of unique values
            this.xDomain = [...new Set(this.currentData)]

            // create X axis scale (discrete)
            this.xScale = d3.scaleBand()

            /* Create Bins for Discrete Data */

            // Count the number of each category
            this.histData = this.currentData.reduce((acc, curr) => {
                const foundObject = acc.find(e => e.value === curr);
                if (foundObject) ++foundObject.count;
                else acc.push({
                    value: curr,
                    count: 1
                });
                return acc;
            }, []);

            // Create Individual Arrays for each category
            this.bins = this.histData.map(item =>
                Array(...Array(item.count)).map(() => item.value)
            )

            // Add x0 property, which is the category name
            this.bins.forEach(el => el.x0 = el[0]);


        } else { // If the data is continuous 
            console.log("values are continuous")
            // create X axis scale (Continuous)
            this.xScale = d3.scaleLinear()

            this.xScale.domain(d3.extent(this.currentData)).nice()
                .range([this.margin.left, this.width - this.margin.right])


            this.binThresholds = this.xScale.ticks(20)

            /* Create Bins for Continuous Data */
            this.bins = d3.histogram()
                .domain(this.xScale.domain())
                .thresholds(this.binThresholds)
                (this.currentData)

        }

        this.min = d3.min(this.currentData);
        this.max = d3.max(this.currentData);

    }

    initialiseChart(data) {
        // Initial Variable
        this.data = data;
        this.variable = "Average Daily % Combo Trucks-Linked Rd";

        // initial data
        this.currentData = data.map(d => d[this.variable])

        // variable name
        this.currentData.x = this.variable;
        this.currentData.y = "Count";

        // From the first element of values, check if string
        this.discreteFlag = typeof this.currentData[0] === "string" ? true : false

        // Create Binned Data
        this.binCreator()

        //         console.log("bins: ", this.bins)


        // find data range
        const yMin = d3.min(this.currentData, d => d.length);
        const yMax = d3.max(this.currentData, d => d.length);

        // initialize y scale
        this.yScale = d3.scaleLinear()

        var element = document.getElementById("chartSVG");

        //If it isn't "undefined" and it isn't "null", then it exists.
        if (typeof(element) != 'undefined' && element != null) {
            d3.select('#chartSVG').remove()
        }

        // add chart SVG to the page
        const svg = d3
            .select('#chart')
            .append('svg')
            .attr('id', 'chartSVG')
            .attr('width', this.width + this.margin['left'] + this.margin['right'])
            .attr('height', this.height + this.margin['top'] + this.margin['bottom'])
            .append('g')
        //             .attr(
        //                 'transform',
        //                 `translate(${this.margin['left']}, ${this.margin['top']})`
        //             );


        // set x-scale domain
        // Discrete Data
        if (this.discreteFlag) {
            this.xScale.domain(xDomain)
                .range([this.margin.left, this.width - this.margin.right])
                .padding(0.2)
        } else {
            this.xScale.domain(d3.extent(this.currentData)).nice()
                .range([this.margin.left, this.width - this.margin.right])
        }
        // set y-scale domain
        this.yScale.domain([0, d3.max(this.bins, d => d.length)]).nice()
            .range([this.height - this.margin.bottom, this.margin.top])

        // set color scale
        this.colorScale = d3.scaleSequential()
            .domain([d3.min(this.bins, d => d.length), d3.max(this.bins, d => d.length)])
            .interpolator(d3.interpolateRdYlBu);

        // create Y axis scale

        /* Create Axes */
        this.xAxis = svg
            .append('g')
            .attr('class', 'xAxis')
            .attr("transform", `translate(${this.margin.top},${this.height - this.margin.bottom})`)
            .call(d3.axisBottom(this.xScale).ticks(this.width / (this.max - this.min)).tickSizeOuter(0))
            .call(g => g.append("text")
                .attr("x", this.width - this.margin.right)
                .attr("y", +30)
                .attr("fill", "currentColor")
                .attr("font-weight", "bold")
                .attr("text-anchor", "end")
                .text(this.currentData.x)
                .attr("id", "CurrentText"));


        this.yAxis = svg
            .append('g')
            .attr('class', 'yAxis')
            .attr("transform", `translate(${this.margin.left},0)`)
            .call(d3.axisLeft(this.yScale).ticks(this.height / 40))
            .call(g => g.select(".domain").remove())
            .call(g => g.select(".tick:last-of-type text").clone()
                .attr("x", 4)
                .attr("text-anchor", "start")
                .attr("font-weight", "bold")
                .text(this.currentData.y)
                .attr("id", "yCurrentText"));

        svg
            .append('clipPath')
            .attr('id', 'clip')
            .append('rect')
            .attr('width', this.width)
            .attr('height', this.height);



        // generates the rest of the graph
        this.updateChart();
    }


    setDataset(variable) {

        /********************************************************************/
        /*         Remove and Re-add relevant Plot Element                  */
        /********************************************************************/

        var element = document.getElementById("chartSVG");

        //If it isn't "undefined" and it isn't "null", then it exists.
        if (typeof(element) != 'undefined' && element != null) {
            d3.select('#chartSVG').remove()
        }

        // add chart SVG to the page
        const svg = d3
            .select('#chart')
            .append('svg')
            .attr('id', 'chartSVG')
            .attr('width', this.width + this.margin['left'] + this.margin['right'])
            .attr('height', this.height + this.margin['top'] + this.margin['bottom'])
            .append('g')
        //             .attr(
        //                 'transform',
        //                 `translate(${this.margin['left']}, ${this.margin['top']})`
        //             );

        // drop-down menu response
        this.hist = true;
        this.variable = variable;
        this.currentData = this.data.map(d => d[this.variable]);
        this.currentData.x = this.variable;
        this.currentData.y = "Count";

        // From the first element of values, check if string
        this.discreteFlag = typeof this.currentData[0] === "string" ? true : false

        this.binCreator()

        //         console.log("bins: ", this.bins)

        // Discrete Data
        if (this.discreteFlag) {
            this.xDomain = [...new Set(this.currentData)]
            this.xScale.domain(this.xDomain)
                .range([this.margin.left, this.width - this.margin.right])
                .padding(0.2)
        } else {

            this.xScale.domain(d3.extent(this.currentData)).nice()
                .range([this.margin.left, this.width - this.margin.right])
        }

        //         console.log("d3.max(this.bins, d => d.length)", d3.max(this.bins, d => d.length))

        this.yScale.domain([0, d3.max(this.bins, d => d.length)]).nice()
            .range([this.height - this.margin.bottom, this.margin.top])

        /* Create Axes */
        this.xAxis = svg
            .append('g')
            .attr('class', 'xAxis')
            .attr("transform", `translate(${this.margin.top},${this.height - this.margin.bottom})`)
            .call(d3.axisBottom(this.xScale).ticks(this.width / (this.max - this.min)).tickSizeOuter(0))
            .call(g => g.append("text")
                .attr("x", this.width - this.margin.right)
                .attr("y", +30)
                .attr("fill", "currentColor")
                .attr("font-weight", "bold")
                .attr("text-anchor", "end")
                .text(this.currentData.x)
                .attr("id", "CurrentText"));


        this.yAxis = svg
            .append('g')
            .attr('class', 'yAxis')
            .attr("transform", `translate(${this.margin.left},0)`)
            .call(d3.axisLeft(this.yScale).ticks(this.height / 40))
            .call(g => g.select(".domain").remove())
            .call(g => g.select(".tick:last-of-type text").clone()
                .attr("x", 4)
                .attr("text-anchor", "start")
                .attr("font-weight", "bold")
                .text(this.currentData.y)
                .attr("id", "yCurrentText"));

        svg
            .append('clipPath')
            .attr('id', 'clip')
            .append('rect')
            .attr('width', this.width)
            .attr('height', this.height);

        this.updateChart();


    }

    setGraph(variable) {
        // drop-down menu response
        console.log(variable)
        this.hist = false;
        this.yVariable = variable;
        this.xVariable = 'date';
        this.currentData = this.data.map(d => d[this.yVariable]);

        // From the first element of values, check if string
        this.discreteFlag = typeof this.currentData[0] === "string" ? true : false

        /********************************************************************/
        /*         Remove and Re-add relevant Plot Element                  */
        /********************************************************************/

        var element = document.getElementById("chartSVG");

        //If it isn't "undefined" and it isn't "null", then it exists.
        if (typeof(element) != 'undefined' && element != null) {
            d3.select('#chartSVG').remove()
        }

        // add chart SVG to the page
        const svg = d3
            .select('#chart')
            .append('svg')
            .attr('id', 'chartSVG')
            .attr('width', this.width + this.margin['left'] + this.margin['right'])
            .attr('height', this.height + this.margin['top'] + this.margin['bottom'])
            .append('g')
        //             .attr(
        //                 'transform',
        //                 `translate(${this.margin['left']}, ${this.margin['top']})`
        //             );

        /********************************************************************/
        /*                  Scales                                          */
        /********************************************************************/

        // set the date X Scale
        this.xScale = d3.scaleTime()

        // set X domain
        this.xScale.domain(d3.extent(this.data, d => d.date));


        // set X range
        this.xScale.range([this.margin.left, this.width - this.margin.right]);

        // initialize y scale
        this.yScale = d3.scaleLinear()

        // find data range
        const yMin = d3.min(this.data, d => d[this.yVariable]);
        const yMax = d3.max(this.data, d => d[this.yVariable]);


        // set y-scale domain
        this.yScale.domain([0, d3.max(this.data, d => d[this.yVariable])]).nice()
            .range([this.height - this.margin.bottom, this.margin.top])

        this.colorDomain = [...new Set(this.data.map(d => d['Injury Type']))]
        console.log("this.colorDomain: ", this.colorDomain)

        // set color scale - the number of unique items determines colors used
        this.colorScale = d3.scaleOrdinal(d3.schemeRdYlBu[this.colorDomain.length])
            .domain(this.colorDomain)


        /********************************************************************/
        /*                  Axes                                            */
        /********************************************************************/

        // Create X Axis
        this.xAxis = svg
            .append('g')
            .attr('class', 'xAxis')
            .attr("transform", `translate(${this.margin.top},${this.height - this.margin.bottom})`)
            .call(d3.axisBottom(this.xScale)
                .ticks(d3.timeMonth)
                .tickSize(16, 0)
                .tickFormat(d3.timeFormat("%B")))
            .call(g => g.append("text")
                .attr("x", this.width - this.margin.right)
                .attr("y", +30)
                .attr("fill", "currentColor")
                .attr("font-weight", "bold")
                .attr("text-anchor", "end")
                .text(this.titleCase(this.xVariable))
                .attr("id", "CurrentText"));

        this.yAxis = svg
            .append('g')
            .attr('class', 'yAxis')
            .attr("transform", `translate(${this.margin.left},0)`)
            .call(d3.axisLeft(this.yScale).ticks(this.height / 40))
            .call(g => g.select(".domain").remove())
            .call(g => g.select(".tick:last-of-type text").clone()
                .attr("x", 4)
                .attr("text-anchor", "start")
                .attr("font-weight", "bold")
                .text(this.titleCase(this.yVariable))
                .attr("id", "yCurrentText"));

        svg
            .append('clipPath')
            .attr('id', 'clip')
            .append('rect')
            .attr('width', this.width)
            .attr('height', this.height);


        // generates the rest of the graph
        // From the first element of values, check if string
        this.discreteFlag = typeof this.currentData[0] === "string" ? true : false

        //         console.log("d3.max(this.bins, d => d.length)", d3.max(this.bins, d => d.length))

        this.yScale.domain([0, d3.max(this.data, d => d[this.yVariable])]).nice()
            .range([this.height - this.margin.bottom, this.margin.top])

        this.updateChart();
    }


    updateChart() {
        /* Remove the axes and title text*/
        d3.select('#xCurrentText').remove()
        d3.select('#yCurrentText').remove()
        d3.select('#titleText').transition(this.t).remove()

        if (this.hist) {
            this.currentData.x = this.currentData.x;
            this.currentData.y = this.currentData.y;
        } else {
            this.currentData.x = this.xVariable;
            this.currentData.y = this.yVariable;
        }

        //         Update the axes */
        d3.select('.xAxis')
            .attr("transform", `translate(0,${this.height - this.margin.bottom})`)
            .call(d3.axisBottom(this.xScale))
            .call(g => g.append("text")
                .attr("x", this.width - this.margin.right)
                .attr("y", +30)
                .attr("fill", "currentColor")
                .attr("font-weight", "bold")
                .attr("text-anchor", "end")
                .text(this.currentData.x)
                .attr("id", "xCurrentText"));
        d3.select('.yAxis')
            .attr("transform", `translate(${this.margin.left},0)`)
            .call(d3.axisLeft(this.yScale).ticks(this.height / 40))
            .call(g => g.select(".domain").remove())
            .call(g => g.select(".tick:last-of-type text").clone()
                .attr("x", 4)
                .attr("text-anchor", "start")
                .attr("font-weight", "bold")
                .text(this.currentData.y)
                .attr("id", "yCurrentText"));

        if (this.discreteFlag) {
            d3.selectAll('g.xAxis g.tick text').each(this.insertLinebreaks);
        } /* Update the volume series bar chart */
        d3.select('#CurrentText').each(this.insertLinebreaks);

        if (this.hist) {
            this.renderVolumeBarCharts();
        } else {
            this.renderGraph();
        }
    }

    renderVolumeBarCharts() {


        // group volume series bar charts, and with clip-path attribute
        d3.select('#chartSVG')
            .append('g')
            .attr('id', 'volume-series')
            .attr('clip-path', 'url(#clip)');

        const chart = d3.select('#chart').select('g');
        //select, followed by join
        const bars = d3
            .select('#volume-series')
            .selectAll('.vol')
            .data(this.bins, d => d);

        bars.join(
            enter =>
            enter
            .append('rect')
            .attr('class', 'vol')
            //             .attr('fake', d => console.log("Scale: ", this.xScale(d.x0) + 1))
            .attr("x", d => this.discreteFlag ? this.xScale(d[0]) : this.xScale(d.x0) + 1)
            .attr("width", d => this.discreteFlag ? this.xScale.bandwidth() : Math.max(0, this.xScale(d.x1) - this.xScale(d.x0) - 1))
            .attr('y', d => this.yScale(d.length) - this.margin.bottom)
            .attr('height', d => this.height - this.yScale(d.length))
            .attr("fill", d => this.colorScale(d.length)),
            update =>
            update
            .transition(this.t)
            .attr("x", d => this.discreteFlag ? this.xScale(d[0]) : this.xScale(d.x0) + 1)
            .attr("width", d => this.discreteFlag ? this.xScale.bandwidth() : Math.max(0, this.xScale(d.x1) - this.xScale(d.x0) - 1))
            .attr('y', d => this.yScale(d.length))
            .attr('height', d => this.height - this.yScale(d.length))
            .attr("fill", d => this.colorScale(d.length))

        );
        d3.select('#chartSVG').append("text")
            .transition(this.t)
            .attr("x", (this.width / 2))
            .attr("y", 0 + (this.margin.top))
            .attr("text-anchor", "middle")
            .style("font-size", "16px")
            .attr("font-weight", "bold")
            .attr("fill", "currentColor")
            .text("Distribution of " + this.variable)
            .attr("id", "titleText");
    }

    renderGraph() {

        d3.select('#chartSVG')
            .append('g')
            .attr('id', 'volume-series')
            .attr('clip-path', 'url(#clip)');


        const chart = d3.select('#chart').select('g');
        //select, followed by join
        const graph = d3
            .select('#volume-series')
            .selectAll('.circle')
            .data(this.data, d => d);

        graph.join(
            enter =>
            enter
            .append('circle')
            .attr('class', 'circle')
            .attr("cx", d => this.xScale(d[this.xVariable]))
            .attr('cy', d => this.yScale(d[this.yVariable]))
            .attr('r', 5)
            .attr("fill", d => this.colorScale(d['Injury Type']))
            .attr("fake", d => console.log(this.colorScale(d['Injury Type']))),
            //             .attr('fake', d => console.log("y: ", this.yVariable))
            //             .attr('fake', d => console.log("y: ", d[this.yVariable]))
            //             .attr('fake', d => console.log("yScale: ", this.yScale(d[this.yVariable]))),
            update =>
            update
            .transition(this.t)
            .attr("cx", d => this.xScale(d[this.xVariable]))
            .attr('cy', d => this.yScale(d[this.yVariable]))
            .attr('r', 5)
            .attr("fill", d => this.colorScale(d['Injury Type']))
        );

        d3.select('#chartSVG').append("text")
            .transition(this.t)
            .attr("x", (this.width / 2))
            .attr("y", 0 + (this.margin.top))
            .attr("text-anchor", "middle")
            .style("font-size", "16px")
            .attr("font-weight", "bold")
            .attr("fill", "currentColor")
            .text("Graph of " + this.xVariable + ' and ' + this.yVariable)
            .attr("id", "titleText");


        this.colorDomain = [...new Set(this.data.map(d => d['Injury Type']))]
        console.log("this.colorDomain: ", this.colorDomain)

        var legendCount = this.colorDomain.length;

        var legendWidth = 10;
        var legendSpacing = 6;

        var legend = d3.select("#chartSVG").selectAll("g.legendg")
            .data(this.colorDomain)
            .enter().append("g")
            .attr('class', 'legendg')
            .attr("transform", "translate(" + (this.width - 200) + "," + 20 + ")");

        legend.append("rect")
            .attr("x", 45)
            .attr("y", (d, i) => i * 15)
            .attr("width", legendWidth)
            .attr("height", legendWidth)
            .attr("class", "legend")
            .style('fill', d => this.colorScale(d));

        legend.append("text")
            .attr("x", (d, i) => 60)
            .attr("y", (d, i) => i * 15 + 5)
            .attr("dy", ".35em")
            .style("text-anchor", "start")
            .text(d => d)
            .attr('fill', d => this.colorScale(d));

    }

}