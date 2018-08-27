clear; 
close all;
clc;

%% Part 1: Email Preprocessing
%  To use an SVM to classify emails into Spam v.s. Non-Spam, you first need
%  to convert each email into a vector of features.

fprintf('\nPreprocessing sample email (emailSample1.txt)\n');

% Extracting features
file_contents = readFile('emailSample1.txt');
word_indices = processEmail(file_contents);

fprintf('Word Indices: \n');
fprintf(' %d', word_indices);
fprintf('\n\n');

%% Part 2: Feature Extraction
%  Now, we will convert each email into a vector of features in R^n. 

fprintf('\nExtracting features from sample email (emailSample1.txt)\n');

% Extracing features
file_contents = readFile('emailSample1.txt');
word_indices  = processEmail(file_contents);
features = emailFeatures(word_indices);

fprintf('Length of feature vector: %d\n', length(features));
fprintf('Number of non-zero entries: %d\n', sum(features > 0));

%% Part 3: Training Linear SVM for Spam Classification
%  In this section, we will train a linear classifier to determine if an
%  email is Spam or Not-Spam.

% Loading the spam email dataset, i.e., X and y in MATLAB environment
load('spamTrain.mat');

fprintf('\nTraining Linear SVM (Spam Classification)\n')
fprintf('(this may take 1 to 2 minutes) ...\n')

C = 0.1;
model = svmTrain(X, y, C, @linearKernel);

p = svmPredict(model, X);

fprintf('Training Accuracy: %f\n', mean(double(p == y)) * 100);

%% Part 4: Testing Spam Classification
%  After training the classifier, we can evaluate it on a test set. We have
%  included a test set in spamTest.mat

% Loading the test dataset, i.e., Xtest and ytest in MATLAB environment
load('spamTest.mat');

fprintf('\nEvaluating the trained Linear SVM on a test set ...\n')

p = svmPredict(model, Xtest);

fprintf('Test Accuracy: %f\n', mean(double(p == ytest)) * 100);

%% Part 5: Top Predictors of Spam
%  Since the model we are training is a linear SVM, we can inspect the
%  weights learned by the model to understand better how it is determining
%  whether an email is spam or not. The following code finds the words with
%  the highest weights in the classifier. Informally, the classifier
%  'thinks' that these words are the most likely indicators of spam.

% Sorting the weights and obtining the vocabulary list
[weight, idx] = sort(model.w, 'descend');
vocabList = getVocabList();

fprintf('\nTop predictors of spam: \n');
for i = 1:15
    fprintf(' %-15s (%f) \n', vocabList{idx(i)}, weight(i));
end

fprintf('\n\n');

%% Part 6: Testing the Classifier using New Emails
%  Now that we've trained the spam classifier, we can use it on our own
%  emails.
%  The following code reads in one of these emails and then uses your 
%  learned SVM classifier to determine whether the email is Spam or 
%  Not Spam

% Setting the file to be read in
filename = 'spamSample3.txt';

% Reading and predicting
file_contents = readFile(filename);
word_indices = processEmail(file_contents);
x = emailFeatures(word_indices);
p = svmPredict(model, x);

fprintf('\nProcessed %s\n\nSpam Classification: %d\n', filename, p);
fprintf('(1 indicates spam, 0 indicates not spam)\n\n');

