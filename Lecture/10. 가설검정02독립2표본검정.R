
########################################################
#### 독립 2표본 검정:(Independent two samples test) ####
########################################################

## 두 모집단의 평균이 어느 한 쪽이 큰 지, 작은 지, 같이 않은 지를 
## 통계적으로 검정하는 방법

## 귀무가설 : 성별에 따라 용돈에 차이가 없다. (mu1 = mu2)
## 대립가설 : 성별에 따라 용돈에 차이가 있다. (mu1 != mu2)

id    = 1:13
money = c(30, 50, 50, 60, 70, 30, 70, 40, 50, 70, 60, 40, 50)
gender = c("m", "f", "f", "f", "m", "m", "m", "f", "m", "m", "m", "m", "m")
st2   = data.frame(id, money, gender)

## 1단계 : 각 집단별 정규성 검정
## by(데이터병$변수명, 데이터명$변수명, shapiro.test)
## by(   양적자료    ,    질적자료    , shapiro.test)
by(st2$money, st2$gender, shapiro.test)

## 결론 : 정규성 가정이 만족됨

## 2단계 : 등분산성 검정(Equality of Variance test)
## 귀무가설 : 등분산이다. (여자집단과 남자집단의 분산이 같다.)
## 대립가설 : 이분산이다. => 등분산이 아니다.

## var.test(데이터명$변수명 ~ 데이터명$변수명)
## var.test(    양적자료    ~    질적자료    )
var.test(st2$money ~ st2$gender)

## 결론 : 등분산이다.

## 3단계 : 등분산이 가정이된 독립 2표본 t검정
## t.test(데이터명$변수명 ~ 데이터명$변수명,
##        alternative = 크다,작다,같이 않다
##        var.equal = TRUE(등분산이다) )
t.test(st2$money ~ st2$gender,
       alternative = "two.sided",   # default = two.sided
       var.equal   = TRUE)

## 결론
## 유의확률이 0.805이므로 유의수준 0.05에서
## "성별에 따라 용돈에 차이가 없다"는 귀무가설을 기가할 수 없다.
## 성별에 따라 용돈에 통계적으로 유의한 차이는 없는 것으로 나타났다.

## 만약에 정규성 가정이 만족되고
## 이분산이라면
## 3단계 : 이분산이 가정된 독립 2표본 T검정
##  t.test(st2$money ~ st2$gender,
##         alternative = "two.sided",   # default = two.sided
##         var.equal   = FALSE)
t.test(st2$money ~ st2$gender,
       alternative = "two.sided",   # default = two.sided
       var.equal   = FALSE)

## 귀무가설이 맞다는 가정하에서 t라는 값이 75.1% 일어날 수 있다.

t.result = t.test(st2$money ~ st2$gender,
                  alternative = "two.sided",   # default = two.sided
                  var.equal   = FALSE)
str(t.result)


## 만약에 정규성 가정이 깨졌다면
## 2단계 : 윌콕슨의 순위합 검정(Wilcoxon's rank sum test)
##  wilcox.test(데이터명$변수명 ~ 데이터명$변수명,
##              alternative = "two.sided")
wilcox.test(st2$money ~ st2$gender,
            alternative = "two.sided")


## Wilcoxon's rank sum test
## Mann-Whitney test => 동일한 결과

