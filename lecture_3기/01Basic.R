# 주석=설명=comment
# 명령어의 끝 : ;
# 명령어의 실행 : Ctrl + Enter
# 다음 줄로 이동 : Enter
# Argument 위치 맞추기 : Shift + Enter
# 대소문자 구분 : Case Sensitive

# 1. 연산자(Operator) ----
# 1.1 산술 연산자(Arithmetic Operator) ----
# +, -, *, /, **, ^, %%, %/%
3 + 4    # 더하기
3 - 4    # 빼기
3 * 4    # 곱하기
3 / 4    # 나누기
3 ** 4   # 거듭제곱
3 ^ 4    # 거듭제곱
13 %% 4  # 나머지
13 %/% 4 # 몫

# 1.2 할당 연산자(Allocation Operator) ----
# <-, =
x <- 1:10
mean(x)
mean(x, trim = 0.1)


# 1.3 비교 연산자(Comparison Operator) ----
# >, >=, <, <=, ==, !=, !
3 > 4
3 >= 4
3 < 4
3 <= 4
3 == 4
3 != 4
!(3 == 4)


# 1.4 논리 연산자(Logic Operator) ----
# &, |
(3 > 4) & (4 < 5)
(3 > 4) | (4 < 5)



# 2. 데이터의 유형(Type of Data) ----
# 데이터의 하나의 값이 무엇으로 이루어 졌는가?
# 2.1 Character : 문자형
x1 <- 'Love is choice.'
x2 <- "buillee"

# 2.2 Numeric   : 수치형, integer(정수), double(실수)
x3 <- 10
x4 <- 10.5

# 2.3 Logical   : 논리형, TRUE, FALSE, T, F
x5 <- TRUE
x6 <- FALSE



# 3. 데이터의 유형 알아내기
# 3.1 mode(data)
mode(x1)
mode(x3)
mode(x5)

# 3.2 is.xxxx(data)
is.character(x1)
is.numeric(x1)
is.numeric(x3)
is.logical(x5)
