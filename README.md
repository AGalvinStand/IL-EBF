# Illinois Evidence-based funding (EBF) simulator

![](https://media4.giphy.com/media/Ojdip0p80ucZh8WjMO/giphy.gif?cid=790b76116acab4a461f02240148b9daf865621db3535395d&rid=giphy.gif&ct=g)

## Goal

Create a school funding simulator to explore the effects of policy proposals currently being discussed among education policy advocates and the EBF Professional Review Panel (PRP).

## Proposed options

### Primary objective for proposed options

We will use this as a tool to simulate options being proposed by PRP and policy groups. These include:

1. **Changes to the additional investments piece of the formula**, which will include adding additional weights<sup>1</sup> for:
    - Concentrated poverty weights;
    - Race.
2. **Changes to the Minimum Funding Level (MFL) and/or the year full funding will be realized**.<sup>2   

### Secondary objective for proposed options:

Exploring ideas that we have an interest in. This includes, so far (10/11/2022):

1. **Changes to the local capacity target (LCT)**, namely an option to see how state funding changes if poorer districts could free up their property levy for capital projects and services.
    
### Functionality 

We will study the effects of these policy changes (e.g. $\textcolor{orange}{\text{input 'levers' on left-panel}}$) on:
    
* the quantitative relationship between school funding (local and state) and race, poverty, income, and  property wealth (e.g. $\textcolor{orange}{\text{scatter plot tabs}}$); 
* the spatial relationship between school funding and race, etc. (e.g. $\textcolor{orange}{\text{a map tab}}$);
* the change in the adequacy target and gap (e.g. $\textcolor{orange}{\text{right-side panel statistics}}$); and 
* how long it will take to fully fund Illinois schools or (conversely) how much the MFL would need to increase each year to achieve a goal of fully funded schools by X date (e.g. $\textcolor{orange}{\text{right-side panel statistics}}$).

Additionally, depending on time and feasibility, we will create a tab for downloadable tables of the different policy options (e.g. $\textcolor{orange}{\text{a downloadable table tab}}$).

Users will be able to toggle on and off the additional investments (e.g. $\textcolor{orange}{\text{checkboxInput}}$) and change the MFL/Year and LCT (e.g. $\textcolor{orange}{\text{numericInput}}$). 

See examples of the input toggles [here](https://shiny.rstudio.com/images/shiny-cheatsheet.pdf).
    
#### Footnotes:
1) We keep the additional investment policy proposals to two additional weights to keep things simple, though depending on time and interest we can add to this.
2) The MFL is a target (not a mandate) for the state to increase educational funding by at least $350 million each year. With the exception of 2020, State Legislators have done this. See section (g)(9) of the EBF legislation, [public act 100-0465](https://www.ilga.gov/legislation/publicacts/100/PDF/100-0465.pdf), for the langauge on MFL.  However, there are two issues at play with the MFL. *First*, $50 million of the $350 million is for property tax relief. In other words, it doesn't increase funding it reimburses districts to account for the fact that lower wealth districts are pressured to increase their property tax rates to fund eduction (among other government goods and services). The secondary objective 1 is proposed as an aveneue to reduce property tax burden through increased state spending as opposed to reimbursing school districts after the fact. Viewed in another way, the tax payer does not see the benefits of the property tax relief grant. This might be an avenue to benefit the working class tax payer while also fully funding schools. *Second*, legislators, for lack of backbone or care, have interpreted the MFL as a 'ceiling rather than a floor', to paraphrase a Professional Review Panel member. The primary objective 2 (PO2) is based on the agrument that if the MFL viewed (in practice) as the yearly target, then it stands to reason that the MFL should actually be the minimum funding level necessary to achieve full funding at an agreed upon date. PO2 would allow uses to see either 1) when full funding would be achieved by exploring various MFL changes, or 2) the necessary MFL yearly increase to achieve full funding by a specified year. 

## Publicizing the funding simulator

We will discuss the possibility of rolling out the simulator publicly (i.e. a presser or promoting it through our organizations' social networks) taking into account that we would first have communication with ISBE and our respective organizations. The goal is to provide a useful tool for policy advocates, not rock the boat.

## Post project data sharing

After the Bellwether course, we will all have access to the data and scripts created during the course to follow our own pursuits.

## Project task notes (10/11/2022)
    
We can use Projects to plan out and assign the tasks that need to be completed. As of 10/11/2022 these include the following:

1. **EBF data cleaning** (the product: an EBF base calculation dataframe with a) the EBF adequacy target and gap and tier funding and b) variables and new calculations for our additional weights). This will include:

    a) Download and use the [2023 EBF Calculation data](https://www.isbe.net/ebfdist) (This may require checking to see if the 2022 and 2023 xlsx files match up, otherwise we will need to revise the scripts.)

    b) Correcting rounding errors in our EBF calc scripts;
    
    c) Correcting the tier allocation rates to account for our weights; and
    
    d) Adding policy weight coding and variables to the additional investments, core investments, and (therefore) the base calculation (which will be used as the primary input for our ui.r and server.r scripts).
    
2. **Build out UI structure** (Product: an outline using "# ----" text to outline our inputs.
3. **Build out server structure** (Product: an outline using "# ----" text to outline the outputs associated with the ui inputs.

*Next steps after 1-3 will be to add the code to build out the inputs and outputs.*

## Miscellaneous
    
### Data cleaning & prep work
    
There is no need to suffer beautifully and recreate the enitre funding formula in R. As we discussed before, we will use what we have so far as our starting point so that we can focus on building out the dashboard.
    
We still need to work out a couple kinks so our numbers match ISBE's numbers: 1) rounding errors and 2) the tier funding allocations. These are laid out in "Project task notes" and will be updated on github projects.
