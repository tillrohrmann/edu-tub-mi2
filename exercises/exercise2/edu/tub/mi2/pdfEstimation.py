'''
Created on Apr 29, 2012

@author: Till Rohrmann
'''

import Image;
import sys;
import random;
import numpy as np;
import matplotlib.pyplot as plt;

EPS = 10 ** -12;


def splitSet(dataset, number):
    selection = [];
    for i in range(len(dataset)):
        selection.append((random.random(),i));
        
    selection.sort();
    
    sample = [];
    test = [];
    for i in range(number):
        sample.append(dataset[selection[i][1]]);
    
    for i in range(number,len(dataset)):
        test.append(dataset[selection[i][1]]);
                
    return((sample,test));

def logLikelihood(distribution, testset):
    result = 0;
    
    for datapoint in testset:
        result -= np.log(distribution[int(datapoint*255)]);
        
    return result;



def loadImage(imageName):
    fp = open(imageName);
    im = Image.open(fp);
    return im;

def normalizeData(data):
    result = [d/255.0 for d in data];
    
    return result;

def denormalizeData(data):
    result = [int(d*255) for d in data];
    
    return result;

def abounds(value,minv,maxv):
    if(value < minv):
        return minv
    elif (value > maxv):
        return maxv;
    else:
        return value;

def applyGaussianNoise(data,sigma):
    result = [ abounds(d + random.gauss(0,sigma),0,1) for d in data];
    return result;

def estimateProbabilityRect(samples,h):
    distribution =[0 for i in range(256)];
    samples.sort();
    right = 0;
    pos = 0;
    idx = 0;
    for _ in range(int(1/h)):
        right += h;
        counter = 0;
        while(pos < len(samples) and( samples[pos] < right or (right == 1.0 and samples[pos] <= right))):
            counter +=1;
            pos+=1;
        value= 1/h*1/len(samples)*counter;
        for i in range(idx,int(right*256)):
            distribution[i] = value;
        idx = int(right*256);
    
    if right != 1.0:
        numRest = len(samples) - pos;
        value = numRest/len(samples)/(1.0-right);
        for i in range(idx,256):
            distribution[i] = value;
        
    return distribution;

def estimateProbabilityGauss(samples, h):
    distribution = [0 for _ in range(256)];
    
    for i in range(256):
        value =0;
        mean = i/255.0;
        for point in samples:
            value += 1/np.sqrt(2*np.pi)/h*np.exp(-(point-mean)*(point-mean)/(2*h*h))
            
        distribution[i] = value/len(samples);
    return distribution;

def plotDistributionHist(distribution,h):
    bins = np.arange(0,1,h);
    values = [];
    temp =0;
    while(np.abs(1.0-temp) > EPS):
        idx = int(temp*256);
        temp += h;
        values.append(distribution[idx]);
        
    plt.bar(left=bins*255,height=values,width=h*255,bottom=0);
    plt.title('Rectangular Kernel, Width:' + str(h));
    plt.xlim(0,255);
    plt.ylabel('Probability');
    
def plotDistributionGauss(distribution,h):
    plt.plot(range(0,256),distribution);
    plt.title('Gaussian Kernel, Hyperparameter:'+str(h))
    plt.ylabel('Probability');
    plt.xlim(0,255);

def runStandalone():
    if len(sys.argv) < 2:
        imageName = "../../../testimg.jpg";
    else:
        imageName= sys.argv[1];
        
    image = loadImage(imageName);
    origData = list(image.getdata());
    origData = normalizeData(origData);
    
    sigmas = [0.05,0.1];
    ps = [100,500];
    hs = [0.2,0.1,0.05];
    
    font = {'size'   : 8}

    plt.rc('font', **font)
    
    for sigma in sigmas:
            data = applyGaussianNoise(origData,sigma);
            for p in ps:
                    plt.figure();
                    plt.suptitle('Sigma:'+str(sigma) + ' Samples:' + str(p));
                    (samples,_) = splitSet(data,p);
                    counter =1;
                    for h in hs:
                        distributionRect = estimateProbabilityRect(samples,h);
                        distributionGauss = estimateProbabilityGauss(samples,h);
                        plt.subplot(len(hs),2,counter);
                        plotDistributionHist(distributionRect,h);
                        counter += 1;
                        plt.subplot(len(hs),2,counter);
                        plotDistributionGauss(distributionGauss,h);
                        counter += 1;
                    plt.show(block=False);
                    
    hsx = [0.2,0.1,0.075,0.06,0.05,0.043,0.035,0.025,0.016,0.01,0.005];
                    
    for sigma in sigmas:
        data =applyGaussianNoise(origData,sigma);
        for p in ps:
            (samples,tests) = splitSet(data,p);
            plt.figure();
            plt.suptitle('Sigma:' + str(sigma) + ' Samples:' + str(p));
#            hRect = [];
            hGauss = [];
            for h in hsx:
#                distributionRect = estimateProbabilityRect(samples,h);
                distributionGauss = estimateProbabilityGauss(samples,h);
#                hRect.append(logLikelihood(distributionRect, tests));
                hGauss.append(logLikelihood(distributionGauss,tests));
            plt.plot(hsx,hGauss,'g');
            plt.legend('Gaussian Kernel');
            plt.title('Gaussian Kernel, Sigma:' + str(sigma) + ' Samples:' + str(p));
            plt.show(block=False);
            
    raw_input('Press button to finish');
        
if __name__ == '__main__':
    runStandalone();
