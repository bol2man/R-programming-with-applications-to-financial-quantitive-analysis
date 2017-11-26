########################################################
# Description:
# 1.for Book 'R with applications to financial quantitive analysis'
# 2.Chapter: CH-12-04
# 3.Section: 12.4
# 4.Purpose: 
# 5.Author: Changjiu Wang, polished by Qifa Xu
# 6.Date: Apr 03, 2014.
# 7.Revised: Sep 01, 2014.
########################################################
# Contents:
# 1. define a function
# 2. implement option pricing
#############################################################
# 0. initializing
# (1) set path
setwd('F:/programe/book/R with application to financial quantitive analysis/CH-12')
rm(list=ls())

# (2) load packages
library(rmr2)                             #����rmr2�����
#������Ҫ�ĳ̼�����Rcpp
#������Ҫ�ĳ̼�����RJSONIO
#������Ҫ�ĳ̼�����bitops
#������Ҫ�ĳ̼�����digest
#������Ҫ�ĳ̼�����functional
#������Ҫ�ĳ̼�����reshape2
#������Ҫ�ĳ̼�����stringr
#������Ҫ�ĳ̼�����plyr
#������Ҫ�ĳ̼�����caTools


# 1. define a function
#���������������ؿ��巽������ŷʽ��Ȩ�۸�EurOptionPrΪ���������ú�����7���������S0��K��T��r��sigma��M��N
#S0����ǰ����ʲ��۸�
#K����Ȩ��Լ��ִ�м۸�
#T����Ȩ��Լʣ����Ч��
#r���޷�������
#sigma���껯������
#M��ģ���ʲ��۸�·������Ŀ
#N��ģ���ʱ��ڵ����Ŀ
EurOptionPr <- function(S0,K,T,r,sigma,M,N){
  inp<-cbind(S0*rep(1,M),rep(0,M))
  inp<-to.dfs(inp)
  buildTraj<-function(k,v){
    deltaT<-T/N
    for(i in 1:N){
      dW<-sqrt(deltaT)*rnorm(length(v[,1]))
      v[,2]<-v[,1]+r*v[,1]*deltaT+sigma*v[,1]*dW
      v[,1]<-v[,2]
    }
    key<-ifelse(v[,1]-K>0,"call","put")
    value<-ifelse(v[,1]-K>0,exp(-r*T)*(v[,1]-K),exp(-r*T)*(K-v[,1]))
    keyval(key,value)
  }
  price.reduce.fn<-function(k,v){
    keyval(k,mean(v)*(length(v)/M))
  }
  OptionPr<-mapreduce(input=inp,map=buildTraj,reduce=price.reduce.fn)
  print(from.dfs(OptionPr))
}

# 2. implement option pricing
#�������������˴�����S0=50��K=52��T=5/12��r=0.1��sigma=0.4��M=1000��N=100
EurOptionPr(50,52,5/12,0.1,0.4,1000,100)
