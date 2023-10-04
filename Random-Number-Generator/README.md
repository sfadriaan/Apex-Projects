# Random Number Generator
# Choose a Winner at Random: The Salesforce Way

Lucky draws are always exciting! You can find them everywhere! At a school fundraiser, a carnival, the national lottery or when you buy two bars of chocolate and can win a Toyota Auris.

Most lucky draws that I have seen have some mechanical aspect to choosing the winner. Either it is a ball with a certain number that is selected for a lottery draw, or someone that puts their hand in a bag and pulls a ticket out with the winner’s number on it. 

But have you ever wondered how online lucky draws work that does not necessarily have a mechanical way of determining a winner? 

At first thought you would think that a winner is selected at random using a random function. That would be the easiest way of doing it, but not all random functions are created equal.  

The random function in Google Sheets and the random function in Apex outputs completely different things. Their inputs are also different. 

So for Salesforce we have the Apex function:

```
math.random()
```

From the [documentation](https://developer.salesforce.com/docs/atlas.en-us.apexref.meta/apexref/apex_methods_system_math.htm#apex_System_Math_random) it states that it will return a positive Double that is greater than or equal to 0.0 and less than 1.0. An example output is 0.030741546727204083. Nothing much to it. There are no inputs or options that you can use to manipulate the output.

From the example output you would rightly think: how will I use that to determine a winner. Apart from giving participants a number between 0.0 and 1.0, that value is not going to work. If you cast the output given to an Integer, you will always get 0 which is not helpful either.

Multiplying it with an upper value (say the number of people that entered), would change the output to be between 0 and the multiplier:

```
Double randomDouble = Math.random();
Integer MULTIPLIER = 10;
Integer randomNumber = (Integer)(randomDouble * MULTIPLIER);
```

You can also add 1 to the `randomNumber` variable to shift your output to be between 1 and the multiplier inclusive. 

Is the above enough to use for randomly selecting a winner? 

Let’s run a Monte Carlo simulation by assuming that we have 20 entrants and we are going to run 80000 random draws. 

The results look like this:

![](https://github.com/sfadriaan/Apex-Projects/blob/main/Random-Number-Generator/Number%20Of%20Times%20Participant%20Was%20Randomly%20Selected.svg)

Now at first sight it looks promising as all entries are chosen at random around the 4000 mark. The standard deviation is approximately 83. From the graph, there is no significant evidence that the random selection is biased towards any lower or upper values.

<img src="https://github.com/sfadriaan/Apex-Projects/blob/main/Random-Number-Generator/but-nicola-foti.gif" width="40%">

But, I did not like the fact that the decimals are so fine and that at random, for a multiplier of 10, the values:

- 0.030741546727204083
- 0.070741546727204083
- 0.090741546727204083
- 0.010741546727204083

will all result in the value of 0 when cast to Integer. 

Now you could argue that I am using a very small multiplier and this would not be the case if there were 1000s of entrants. This is true, but I wanted to build a solution that is accurate for any scenario.

So I did some research and found a math function that can solve my problem (at least to some extent):

```
math.mod()
```

Basically what `math.mod()` does (see documentation [here](https://developer.salesforce.com/docs/atlas.en-us.apexref.meta/apexref/apex_methods_system_math.htm#apex_System_Math_mod_2)) is return the remainder of a division. Some examples include:

```
math.mod(7, 2) = 1
math.mod(9, 3) = 0
math.mod(707415467272, 879) = 385
```

So I can randomly generate a number, multiple it by any given number and mod it with the number of entries. I will always get an integer value back between 0 and the number of entries exclusive:

```
Integer MULTIPLIER = 1000000;
Double randomDouble = Math.random();
Integer randomNumberMultiplied = (Integer)(MULTIPLIER * randomDouble);
Integer randomNumber = math.mod(randomNumberMultiplied,10)
```

Let us follow the same route with the previous solution and do a Monte Carlo simulation of 80000 random selections of a pool of 20 entries. 

The graph shows the absolute difference between the average and the amount randomly selected for each entrant from both tests: 

![](https://github.com/sfadriaan/Apex-Projects/blob/main/Random-Number-Generator/Deviation%20From%20Average%20Per%20Entrant.svg)

The standard deviation for the first test is 4000 ± 83 whereas the second test’s standard deviation is 4000 ± 62. 

As far as my limited statical skills can take me, I would say the second one is better! 

What do you think? Any experience using `math.random()`?