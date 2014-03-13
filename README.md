Dance Music Segmentation
======================

Segmenting electronic dance music streams based on self-similarity

- Tim Scarfe (http://www.developer-x.com)
- Wouter M.~Koolen (http://wouterkoolen.info/)
- Yuri Kalnishkan (http://www.clrc.rhul.ac.uk/people/yura/)

We present an unsupervised, deterministic algorithm for segmenting DJ-mixed Electronic 
Dance Music (EDM) streams (for example; pod-casts, radio shows, live events) into their 
respective tracks. We attempt to reconstruct boundaries as close as possible to what a 
human domain expert would create in respect of the same task. The goal of DJ-mixing is 
to render track boundaries effectively invisible from the standpoint of human perception 
which makes the problem difficult.

We use dynamic programming to optimally segment a cost matrix derived from a similarity matrix. 
The similarity matrix is based on the cosines of a time series of kernel-transformed Fourier 
based features designed with this domain in mind. Our method is applied to EDM streams. 
Its formulation incorporates long-term self similarity as a first class concept combined 
with dynamic programming and it is qualitatively assessed on a large corpus of long streams 
that have been hand labelled by a domain expert.

In laymans terms, the purpose of this software is to automatically generate a cue sheet in
the situation that you have downloaded a radio show like A State of Trance and you have only
the track list. Web sites already exist where humans manually create cue sheets i.e. http://cuenation.com/
The problem is you have to rely on them (you can't automate the process) and as I have seen first 
hand they make a lot of mistakes on the indexes. They are obsessed with "precision" while often failing
on basic accuracy. Manually finding the indices is (I think) a laborious error-prone task. I can't quite believe 
that they have the will or the inclination to do it manually, but they do. A potential fork of this
project would be to use the self-similarity matrix visualization as a helper for them to do it manually faster.

See http://www.developer-x.com/papers/trackindexes for more information and associated papers.

On this github project we supply the working code with a sample test set in ./Matlab/examples.
The project is written in Matlab although some helper functions i.e. for pre-processing the dataset,
extracting cue sheet times etc are included as part of a Visual Studio project.

Simply execute run_experiments.m to predict the track indexes for the test dataset which is:

- A State of Trance (With Armin van Buuren) 453 + 462
- Trance Around World (with Above and Beyond) 364 + 372
- Magic Island (with Roger Shah) 98 + 112

This is free software. Feel free to fork or contribute. It would be particularly useful if somebody 
is interested in creating an implementation of this in a more serious language like C, Java, C# etc. 
I would be happy to collaborate. Get in touch.

I would like to personally thank Dennis Goncharov for providing me with a dataset complete with cues
for my research and also Mikael Lindgren from CueNation. Both provided me with insight on how they
find the optimal track indices. The dataset I have from Dennis is quite large but I will supply it on request.
