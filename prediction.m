clear all;
clc;
load dataINR

t = dataUSD2INR(:, 1); 
x = dataUSD2INR(:, 6); 
figure(1); 
plot(t,x);

for k=9:1080,
% Putting one week, 2 and 1 day delay and +1 and 2 days
Data(k-8,:)=[x(k-7) x(k-2) x(k-1) x(k) x(k+1) x(k+2)];
end
len=size(Data);

% The Training Data
TRNData=Data(1:(len(1)/2), :);
% The Checking Data
CHKData=Data(((len(1)/2)+1):end, :);

FIS = genfis1(TRNData);
figure(2)
%plotting the membership functions
for i=1:5
subplot(2,3,i)
plotmf(FIS, 'input', i)
end

% Creating the ANFIS
[FIS,ERROR,STEPSIZE,CHKFIS,CHKERROR] = anfis(TRNData,FIS,[],[],CHKData);

figure(3)
% plotting the membership functions
for j=1:5
subplot(2,3,j)
plotmf(CHKFIS, 'input', 1)
end
figure(4)
TRN=[TRNData(:,1) TRNData(:,2) TRNData(:,3) TRNData(:,4) TRNData(:,5)];
CHK=[CHKData(:,1) CHKData(:,2) CHKData(:,3) CHKData(:,4) CHKData(:,5)];
output = evalfis([TRN; CHK], CHKFIS);
index = 1:len(1);
t = dataUSD2INR(:, 1);
% plotting the data and the predicted data
subplot(2,1,1), plot(t(index), [x(index) output]);
% plotting the error
subplot(2,1,2), plot(t(index), x(index) - output,'r');
figure(5)
plot([ERROR; CHKERROR]);