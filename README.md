# TidalNotch_Generator
This repository contains the scripts used in the scientific article entitled: ''Decoding the interplay between tidal notch geometry and sea-level variability during the Last Interglacial (Marine Isotopic Stage 5e) high stand''. 
The files contained are  Matlab scripts. 
1. Random_Notch_Creator contains the main script which generates notch geometries based on randomly selected parameters but also contains the script comparing the modeled notches to the ones measured in reality, using photogrammetry.

The rest of the scripts contain the methodology used to cluster the produced Sea Level Curves (SLCs) that produced the best-fitting modeled notches (>80%).
2. Linear Regression was the first to discriminate SLCs with Positive and Negative direction.
3. Peak finder Separator was used to group SLCs with 1, 2 , 3 or more than 3 peaks. 
4. The final separation of the SLCs was performed using the script Curve_Clustering. We performed the k-means clustering algorithm to choose the most successful SLC clusters. 

5. Production of figure 4 with SLCs density plot was accomplished through script Density_Plots.
