function range(start, end, step) {
    if (isNaN(step) || step === 0) {
        var step = 1;
    }
    rArray = [];
    if (step < 0 && start > end) {
        for (start; start >= end; start += step) {
            rArray.push(start);
        }
        return rArray;
    } else if (step > 0 && start < end) {
        for (start; start <= end; start += step) {
            rArray.push(start);
        }
        return rArray;
    }
}

function sum(array) {
    var sumArray = 0;
    for (ind in array) {
        sumArray += array[ind];
    }
    return sumArray;
}

function reverseArray(array){
    var reversedArray=[];
    for (ind in array){
        reversedArray.unshift(array[ind]);
    } return reversedArray;
}

function reverseArrayInPlace(array){
    var i =0;
    for (i;i < Math.floor(array.length/2); i++){
        var aa = array[i];
        array[i]=array[array.length - i - 1];
        array[array.length - i - 1] = aa;
    } return array;
}

function arrayToList(array){
    list = {};
    for (ind in array){
        list = list{array[ind]}
    }
}
