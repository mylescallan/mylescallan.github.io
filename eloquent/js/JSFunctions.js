var expFunction = function(x) {
    return x * x;
    // square the argument
};

function decFunction(x) {
    return x * x;
}

function highFunction(a) {
    var d,
        e;
    return function secFunction(b) {
        d = a * b;
        return function thiFunction(c) {
            e = d * c;
            return e;
        }
    }
}

high5 = highFunction(5);
sec6 = secFunction(6);
thi7 = thiFunction(7);

