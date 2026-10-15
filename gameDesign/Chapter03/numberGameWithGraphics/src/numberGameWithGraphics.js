
//Game variables
var mysteryNumber = Math.round(Math.random()*100);
var playersGuess = 0;
var guessesRemaining = 10;
var guessesMade = 0;
var gameState = "";
var gameWon = false;

//The input and output fields
var input = document.querySelector("#input");
var output = document.querySelector("#output");

//The button
var button = document.querySelector("button");
button.style.cursor = "pointer";
button.addEventListener("click", clickHandler, false);

//The arrow
var arrow = document.querySelector("#arrow");

function render()
{
  //Position the arrow
  //Multipy the players guess by 3 to get the
  //corrent pixel position on the scale
  arrow.style.left = playersGuess * 3 + "px";
}

function clickHandler()
{
  playGame();
}

function playGame()
{  
  guessesRemaining = guessesRemaining - 1;
  guessesMade = guessesMade + 1;
  gameState = " Guess: " + guessesMade + ", Remaining: " + guessesRemaining;
  
  playersGuess = parseInt(input.value);

  if(playersGuess > mysteryNumber)
  {
    output.innerHTML = "That's too high." + gameState;
    
    //Check for the end of the game
    if (guessesRemaining < 1)
    {
      endGame();
    }
  }
  else if(playersGuess < mysteryNumber)
  {
    output.innerHTML = "That's too low." + gameState;
    
    //Check for the end of the game
    if (guessesRemaining < 1)
    {
      endGame();
    }
  }
  else if(playersGuess === mysteryNumber)
  {
    gameWon = true;
    endGame();
  }
  
  //Update the graphic display
  render();
}

function endGame()
{
  if (gameWon)
  {
    output.innerHTML
      = "Yes, it's " + mysteryNumber + "!" + "<br>" 
      + "It only took you " + guessesMade + " guesses.";
  }
  else
  {
    output.innerHTML
      = "No more guesses left!" + "<br>" 
      + "The number was: " + mysteryNumber + ".";
  }
}
