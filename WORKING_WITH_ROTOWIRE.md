# Working with the RotoWire NLG datasets
This document gives an overview of things that I believe authors of papers using Rotowire-based datasets, as well as reviewers should know.  This is based on my experience at the University of Aberdeen working on data-cleaning, systems, and evaluation.  The idea for this page came as I was away to tweet (again) about papers that do not acknowledge well known problems in this space and test on training data, a problem that has been known since 2019.  There is a real problem of the kind noted in [Raji et al. 2021](https://arxiv.org/abs/2111.15366) "AI and the Everything in the Whole Wide World Benchmark", whereby the RotoWire task seems to have set in stone without any further investigation as to whether it is a sensible representation of a real-world problem or whether it can be improved.  It was a fantasitc start, but problems have since been found (and some even resolved).

I will update this over time, but I wanted to make this simple landing page so that anyone picking up the dataset does not just assume that the ML task is valid, or at least understands the issues.

## TL;DR
1. There are games in the RotoWire dataset that are present in more than one train/test/validation partition (solution: use partitions based on seasons and/or remove extra games).  There are different references texts for them, but this still means a model trained on one text will just parrot it when presented with the same data at test time (with zero factual errors).  If you take nothin else away from this page take this.
2. BLEU is useless (solution: do not use it or at least acknowledge its limitations when writing)
3. It has not been demonstrated whether rating such lengthy texts for readability, coherence, etc., is useful (these can still be used, just be aware that evaluation in this space is an open problem, much more so than E2E/WebNLG where texts are 1-2 sentences not 5-25)
4. Predicting true facts (RG) is not the same thing as finding errors in a text (a text with more correct facts might not have fewer incorrect facts)
5. There is some recent work on evaluation in this space (read more below)

## The history of the RotoWire data
Originally put together by [Wiseman et al. 2017](https://arxiv.org/abs/1707.08052) and found on [this repo](https://github.com/harvardnlp/boxscore-data) the dataset consists of summaries of basketball games, paired with data taken from the box score (a table of statistics from the game) as well as some other game meta-information.  This dataset really pushed the limits of neural NLG systems, and they are still far from solving it.  [Wang 2019](https://aclanthology.org/W19-8639) added to the dataset by including more games, [the repo](https://github.com/wanghm92/rw_fg) for that paper also includes some procesed data based on their approach.

## Why this repository?
This repository, SportSett [Thomson et al. 2020](https://aclanthology.org/2020.intellang-1.4) has three primary goals.

1. Clean up partitioning problems in the original RotoWire dataset (a problem also observed by [Iso et al. 2019](https://aclanthology.org/P19-1202))
2. To add basic information that commonly occurs in the texts but was not covered by the original dataset.  Examples are stadium names and days of the week.
3. To move beyond the idea of "table-to-text", and acknowledge that these human written summaries are not of one 2D table, but rather a collection of tables (including previous games and other information).

Some of the above are optional augmentations to the ML task, but having train/test contamination is strictly wrong.  Researchers do not have to use our dataset, but they should remove this issue when training models.

## The history of evaluation on RotoWire data
The majority of works only use automated evaluations and in particular, the following:
1. BLEU:  BLEU does not correlate with human judment for NLG [Reiter 2018](https://aclanthology.org/J18-3002).  I strongly suspect it is even worse on RotoWire than on other texts, just because of the nature of the texts (high level of data aggregation, content selection and summarisation).  On this dataset it is worth noting that running BLEU on [deranged](https://en.wikipedia.org/wiki/Derangement) copies of partitions can yield scores as high as 10, and that no system ouptuts are much higher than 20.  In all honesty, if I could omit BLEU from my own work then I would, but I worry that a reviewer would (wronlgly) penalise me for not including it "because everyone else has".  
2. RG and the other IE metrics (CS/CO):  Wiseman et al introduced these metrics with the original dataset.  A model is trained which predicts true facts in the form of extracted triples from the generated (or other) text.  This set of triples is them compared with those from the data record or those extracted from the reference text.  This approach provided a good start, but it may be the case that it only finds 50% of factual errors in the text.  Maximizing RG mentions is also problematic as it may be wrong to have a much higher fact density than human-authored ref texts (as noted by [Rebuffel et al. 2019](https://link.springer.com/chapter/10.1007/978-3-030-45439-5_5)).  Texts can end up verbose, containing many trivial facts rather than the correct number of useful ones.

Some works perform human evaluation, although this is usually only:
1. Ratings on likert scales, which might be problematic on such lengthy texts.  If for example there are four minor errors found in one text, and one major error in another, an annotator might rate both of them 2/5 but we have no way to tell why it was rated as such and cannot perform a meaningful error analysis [van Miltenburg et al. 2021](https://arxiv.org/abs/2108.01182).
2. Counting supported and contradicting facts in single sentences from the generated text based on one input table.  This method has similar problems to the above, we do not know what individual errors are, and it is difficult to check that annotators are doing this work properly.  It also does not detect hallucinations which come from information not in the input data (they are neither supported or contradicted).  It also misses many errors that occur due to context (only one sentence is evaluated at a time).

## Our evaluation work, and the shared task
At Aberdeen we have done a lot of work on evaluation in this space, using the dataset because it represents a hard data-to-text problem of the type defined by [Reiter 2007](https://aclanthology.org/W07-2315), i.e., it is not just transcription of a table/row, there is a data analytics components to the problem.  Our work includes:

1. A Gold Standard Methodology for Evaluating Accuracy in Data-To-Text Systems - [Thomson & Reiter 2020](https://aclanthology.org/2020.inlg-1.22):  Here we propose a method of "evaluation by annotation" where individual errors (non-overlapping spans of tokens) are highlighted and given a category (NAME, NUMBER, WORD, CONTEXT, NOT CHECKABLE, or OTHER).
2. Generation Challenges: Results of the Accuracy Evaluation Shared Task - [Thomson & Reiter 2021](https://aclanthology.org/2021.inlg-1.23/):  Here we ran a shared task where the objective was to find automated metrics (or cheaper human protocols) that correlated with the results obtained from our gold standard annotation of errors in the outputs of 3 well known RotoWire systems.  While the RG metric was not directly evaluated here (it predicts true facts not errors) the system of [Kasner et al. 2021](https://aclanthology.org/2021.inlg-1.25) was the best metric by some margin, beating the submission that was closer in functionality to RG.

I encourage anyone looking at using this dataset, and especially anyone reviewing work based on it, to think about whether their evaluations are meaningful, of if they are just arbitrary numbers to rank systems.

## Comparing with previous systems
This last part is just my opinion, based on working with these systems.  If you are looking for systems to train and compare with your own, I would look at [Macro Plan](https://github.com/ratishsp/data2text-macro-plan-py) and [Hierarchical Transformer](https://github.com/KaijuML/data-to-text-hierarchical).  In my opinion, these two systems are the ones that I have seen generate fewer errors.  The code for both also works.