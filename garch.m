%GARCH
%Garch assumes a return series
load dataINR
isk2usd = price2ret(dataUSD2INR(:,6));
figure(1)
plot(isk2usd)
% set(gca,'XTick',[1 659 1318 1975])
% set(gca,'XTickLabel',{'Jan 1984' 'Jan 1986' 'Jan 1988' ...
% 'Jan 1992'})
ylabel('Return')
title('INR USD daily returns')
figure(2)
%The autocorrelation function
autocorr(isk2usd)
title('ACF with Bounds for Raw Return Series')
figure(3)
% The partial correlation series
parcorr(isk2usd)
title('PACF with Bounds for Raw Return Series')
figure(4)
% Checking for correlation on the squared return
autocorr(isk2usd.^2)
title('ACF of the Squared Returns')
% create a garch(1,1) model
spec11 = garchset('P',1,'Q',1,'Display','off');
[coeff11,errors11,LLF11] = garchfit(spec11,isk2usd);
garchdisp(coeff11,errors11)
% create a garch(2,1) model
spec21 = garchset('P',2,'Q',1,'Display','off');
[coeff21,errors21,LLF21] = garchfit(spec21,isk2usd);
garchdisp(coeff21,errors21)
% create a garch(1,2) model
spec12 = garchset('P',1,'Q',2,'Display','off');
[coeff12,errors12,LLF12] = garchfit(spec12,isk2usd);
garchdisp(coeff12,errors12)
figure(5)
% Display the results of the GARCH(1,1)
[Coeff,Errors,LLF,Innovations,Sigmas,Summary] = garchfit(spec11,isk2usd);
figure(6)
% plotting the data against the model
plot(isk2usd,'r --')
hold
plot(Innovations)
figure(7)
%change the return to a price data
startingpoint=dataUSD2INR(1,6);
modeling=ret2price(Innovations,startingpoint);
plot(modeling,'r');
hold
plot(dataUSD2INR(:,6))
% Finally lets do a forecast
horizon = 30; % Define the forecast horizon
[sigmaForecast,meanForecast,sigmaTotal,meanRMSE] = garchpred(Coeff,isk2usd,horizon);