# Illinois Evidence-based funding (EBF) simulator (working proposal)

![](https://media4.giphy.com/media/Ojdip0p80ucZh8WjMO/giphy.gif?cid=790b76116acab4a461f02240148b9daf865621db3535395d&rid=giphy.gif&ct=g)

## Goal

Create a school funding simulator to explore the effects of policy proposals currently being discussed among education policy advocates and the EBF Professional Review Panel (PRP).

## Proposed options

We can use this as a tool to simulate options being proposed by PRP and policy groups along with our own ideas. In fact, I think after creating this simulator we draft up a white paper and roll it out publicly (i.e. a press release, etc.).

I think we split the simulator's policy 'levers', so to speak, into three buckets: 

1. **Changes to the additional investments piece of the formula**, which will include adding additional weights<sup>1</sup> for:
    - Concentrated poverty weights;
    - Race.
2. **Changes to the Minimum Funding Level (MFL)**.<sup>2   
3. **Changes to the local capacity target (LCT)**, namely an option to see how state funding changes if poorer discricts could free up their property levy for capital projects and services.
    
### Functionality 

We will study the effects of these policy changes (e.g. $\textcolor{orange}{\text{input 'levers' on left-panel}}$) on:
    
* the quantitative relationship between school funding (local and state) and race, poverty, income, and  property wealth (e.g. $\textcolor{orange}{\text{scatter plot tabs}}$); 
* the spatial relationship between school funding and race, etc. (e.g. $\textcolor{orange}{\text{a map tab}}$);
* the change in the adequacy target and gap (e.g. $\textcolor{orange}{\text{right-side panel statistics}}$); and 
* how long it will take to fully fund Illinois schools (e.g. $\textcolor{orange}{\text{right-side panel statistics}}$). 

Users will be able to toggle on and off the additional investments (e.g. $\textcolor{orange}{\text{checkboxInput}}$) and change the MFL and LCT (e.g. $\textcolor{orange}{\text{numericInput}}$). 

See examples of the input toggles ![here](https://shiny.rstudio.com/images/shiny-cheatsheet.pdf).
    
#### Footnotes:
1) I propose we keep it at two additional weights to keep things simple, though I'm open to discuss this.
2) The MFL is a target (not a mandate) for the state to increase educational funding by at least $350 million each year. With the exception of 2020, State Legislators have done this. See section (g)(9) of the EBF legislation ![public act 100-0465](https://www.ilga.gov/legislation/publicacts/100/PDF/100-0465.pdf).  However, there are two issues. First, $50 million of the $350 million is for property tax relief. In other words, it doesn't increase funding it reimburses districts. This is why I proposed the third option, which would increase funding on net. Second, legislators, for lack of backbone, care, or wit -- probably all three -- have interpreted this as this as a 'ceiling rather than a floor', in the words of a Professional Review Panel member. Hence, I added option #2 as a way of exploring the effects of raising the 'ceiling'.

## Work tasks
    
We can use Projects to plan out and assign the tasks that need to be completed.

## Miscellaneous
    
### Data cleaning & prep work
    
There is no need to suffer beautifully and recreate the funding formula in R. As we discussed before, we can use what we have so far as our starting point so that we can focus on building out the dashboard.
    
We still need to work out a couple kinks so our numbers match ISBE's numbers: 1) rounding errors and 2) the tier funding allocations.
