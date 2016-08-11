*** Social Statistics Boot Camp ***

* Lab #2
*Instructor: Marshall A. Taylor

/*
The purpose of this lab is to give you some exposure to generating inferential
statistics and measures of association. Like Monday, we will start with setting
your directory, loading your data, saving master and working files, and starting
a .do file for your code. Then we will run through a couple of examples together.
After that, you will run some analyses of your own and interpret the results.

Section I: Getting Ready
Open Stata. Take a moment to reacquaint yourself with the GUI (graphical user
interface). You have your "Variables" pane to the right, which will populate 
with variable names once you load your data. You also have the "Review" pane to
the right, which logs the commands you have executed. The big pane in the middle
will display your results, and the "Command" pane below that is where you can
write out and execute the code (though, as I said before, you should get in the
habit of using your .do file for this).

Let's first set your working directory with the -cd- command.
*/
cd N:/
/*

Now let's print your working directory to make sure we are now working within 
your N drive.
*/
pwd
/*

Load up the data. We will continue with the 2014 wave of the GSS
(General Social Survey).
*/
use GSS2014, clear
/*

As before, let's now set master working versions of your dataset.
*/
save GSS_master, replace
save GSS_working, replace
/*

Set up a new .do file for your lab code with the -doedit- command.
You can add the name you want to give your .do file by appending whatever you want
after the command. Let's name it YOURLASTNAME.
*/
doedit YOURLASTNAME
/*
A new tab should open next to this one with your .do file.

Something we didn't do Monday was create what is called a log file. This is simply
a record of everything you print to the results pane. Let's start one.
*/
log using YOURLASTNAME.log
/*
That way you can see a record of the different tests you run after you close
your session. When you have finished your lab, you will type -log close-.

Now we're ready to run some analyses!

Section II: Tests of Statistical Inference
Let's start with an independent samples t-test. We are interested in whether or
not people with benefit plans are more likely to have higher incomes than those
without benefit plans.
*/
ttest conrinc, by(depens)
/*

		Thought Experiment #1: What are our null and alternative hypotheses? 
		What does this test tell us? Is there likely a statistically significant 
		difference in the population? If so, in what direction?

Now let's try an independent samples difference-of-proportions test. We are
interested in whether or not people who have been told that they are depressed
are more likely to say they beleive that a person has a right to take their own 
life if they think life is not worth living. Before we run this test, however,
we need to recode our two dichotomous variables as 0 and 1.
*/
gen suic=.
replace suic=0 if (suicide4==1)
replace suic=1 if (suicide4==2)
gen dep=.
replace dep=0 if (depress==1)
replace dep=1 if (depress==2)
/*
The above code works by (1) setting a new variable ("suic" and "dep") with all
missing values (the .), and then (2) relabeling the values according to levels of
the original variables. 

Now we can run the test.
*/
prtest suic, by(dep)
/*

		Thought Experiment #2: What are our null and alternative hypotheses?
		What does this test tell us? Is there likely a difference in the 
		population? In what direction? Why did we choose the difference-of-proportions
		test instead of the t-test?

Now let's try a chi-square test with two nominal variables. We are interested in
whether or not there is a statistically significant relationship between labor
force status (working full-time, part-time, and temporary) and the type of job
people have (for-profit, non-profit/not-for-profit, or government).
*/
tab workfor1 wrkstat, chi2
/*

		Thought Experiment #3: What are our null and alternative hypotheses?
		What does the chi-square test tell us here? Are these two variables likely
		to be related to one another in the population or not? Why did we use
		this particular test?

Now let's use the gamma/ASE test. We are curious if level of fundamentalism is
related to views on pre-marital sex.
*/
tab fund premarsx, gamma
/*
Now we have to divide gamma by its ASE (asymptotic standard error) to get our 
z-statistic. Remember that this test assumes a normal distribution, so we can use
our standard critical values of plus-or-minus 1.96 (.95 two-tailed), 
plus-or-minus 2.58 (.99 two-tailed), 1.64 (.95 one-tailed), and so on.
*/
display "gamma/ASE = " .3974/.031
/*

		Thought Experiment #4: What are our null and alternative hypotheses?
		What does this test tell us? Are these two variables likely to be dependent
		in the population? Why did we use this test?

Section III: Measures of Association with Nominal Variables
Let's consider the substantive significance of the nominal variables in our 
above analyses.

So we know that the relationship between opinions on whether or not a person
should be able to end their own life if they are tired of living ("suicide4") and 
whether or not the person with the opinion has been told they are depressed
("depress") is statistically significant. How substantively significant is this
relationship? Let's get some relative risks, odds ratios, phi-coefficients, and
Cramer's V values to figure this out.

First, some relative risks.
*/
tab suicide4 depress, col
display "RR(depress) = " .3206/.187
/*

Now let's get the odds ratio for the same comparison.
*/
display "OR(depress) = " (.3206/.6794)/(.187/.813)
/*

We can also get Stata to report the relative risks and odds ratios for the variable
along the y-axis for us (this is the case with the "depress" variable).
*/
csi 42 129 89 561, or
/*
The -csi- command automatically gives us the relative risk (a.k.a. the risk ratio),
so we add the ", or" to tell it to also give us the odds ratio.

		Thought Experiment #5: What do the relative risks and odds ratios tell us?
		Do they give us conflicting information? 

We can also get a phi-coefficient for the entire table--not just comparisons
between particular cells of the table. 
*/
tab suicide4 depress, V
/*

		Thought Experiment #6: What does the phi-coefficient tell us about the
		relationship between these variables? Do you think this is a small, 
		moderate, or strong effect? In what direction is the effect, and what
		does that mean? Also, why am I calling this the phi-coefficient, even
		though Stata reports it as Cramer's V?

Finally, we can use Cramer's V to get a measure of association for a table
that is larger than 2X2. Let's use our labor force status and job type variables
from the chi-square test above.
*/
tab workfor1 wrkstat, V
/*

		Thought Experiment #7: What is Cramer's V telling us about the relationship
		between these variables? How "big" is the effect, and what does the
		direction of the effect mean? How is this different from phi?

Section IV: Try it out!
Now try some of this stuff on your own. Specifically, I want you to run ONE of EACH
of the following:

		(a) Independent samples t-test
		(b) Independent samples difference-of-proportions test
		(c) Chi-square test
		(d) Gamma/ASE test

After running the tests, look at some measures of assocation that you think may
be relevant for the difference-of-proportions test and chi-square test. 

For each inference test, answer the following questions/prompts.

		(1) Why did you pick this test?
		(2) Interpret the results in plain language. Be sure to mention your
			null and alternative hypotheses.
			
For each measure of association, please answer the following questions/prompts.

		(1) Why did you pick this measure of association?
		(2) Interpret the result. What does this tell us about the substantive
			significance of the relationship?
			
Please e-mail your responses and .do file to me. The responses can be in either a
separate Word document or right in the .do file.

After you have finished, simply type the following to close your log file.
*/
log close
/*
