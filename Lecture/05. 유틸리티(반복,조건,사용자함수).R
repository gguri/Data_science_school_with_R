###############################################################################
### 수업내용 : 반복분, 조건문, 사용자 함수                                  ###
###                                                                         ###
### 작 성 자 : JuncChul HA                                                  ###
### 작성일자 : 2017.07.20(목)                                               ###
###############################################################################

install.packages("R.utils")
library(R.utils)

###############################################################################


## 1. 반복문 : for
## 동일한 일을 여러 번 하거나 
## 비슷한 일을 여러 번 할 때

## print("메시지")
## cat("메시지1", "메시지2", ..., "메시지k")
for(i in 11:20){
  print("Hello, world!")
}

# in 은 대입, 할당 하는 역할
# 1:10 => 10개의 데이터의 개수만큼 for문이 시행된다. 
# 10개의 데이터만 만들어주면 됨

for(i in 1:10){
  cat("hello,", i, "\n")
}
for(i in 1:10){
  printf("hello, %d \n", i)
}

# 구구단
for(i in 1:9){
  cat(i, "단 이에요!", "\n")
  for(j in 1:9){
    cat(i, "x", j, "=", i*j, "\n")
  }
  cat("\n")
}

# R.utils 패키지 필요
R.utils::printf("hello %d \n", 56 )


##  2. 조건문
##  if, if ~ else, if ~else

x = c(100, 30, 60)
if(x > 50){
  print("Very large number!!!")
}

for(i in 1:3){
  if(x[i] > 50){
    printf("%d Very large number!!! \n", x[i])
  } 
}

##  if(조건문){ 조건이 참일 때 실행문 1 }
##  else{ 조건이 거짓일 때 실행문 2 }
y = 10
if(y > 5){
  print("Large!!")
} else{
  print("Small!!")
}

y = c(10, 4, 6)
for(i in 1:length(y)){
  if(y[i] > 5){
    print("Large!!")
  } else{
    print("Small!!")
  }
}

## if(조건문1){실행문1}else if(조건문2){실행문2}...else{실행문3}
z = 7
if(z>10){
  print("Large")
} else if(z>5){
  print("medium")
} else{
  print("small")
}


##  3. 사용자 함수
##  함수명 = function(){실행문}
hello = function(){
  print("hello, world")
}

# 함수호출 : 함수명()
hello()

# return의 의미
hello = function(){
  print("hello, world")
  return("hello, fastcampus")
}

hello()
x = hello()
x

triple = function(x){
  tmp = 3*x
  return (tmp)
}


triple = function(x){
  if(mode(x) == "numeric"){
 #if(is.numeric(x)) 을 사용해도 된다
    tmp = 3*x
    return (tmp)
  } else{
    print("숫자를 넣어주세요")
  }
}
triple(10)
triple("10")

## 구구단 : 숫자 해당 구구단을 출력
gugudan = function(x){
  if(is.numeric(x)){
    printf("%d단 \n", x)
    for(i in 1:9){
      printf("%d x %d = %d \n", x,i,x*i)
    }
  } else{
    print("숫자를 넣어주세요")
  }
}
gugudan(3)

