rm(list=ls())
# @title xwMooc string처리
# @author JC.Ha
# @version 1.0 2017-09-07

# 00. 설명 --------------------------------------------
# 출처 : http://statkclee.github.io/ml/ 
# 개인 공부용으로 정리하는 내용입니다!

# rebus: Regular Expression Builder, Um, Something: 사람이 읽고 사용하기 쉬운 형태로 바꾼 정규식 구현 팩키지

# stringr: RStudio 개발환경에서 str_ + 탭완성 기능을 조합하여 일관성을 갖고 가장 많이 사용되는 문자열 처리 기능을 함수로 제공하는 팩키지

# stringi: 속도 및 확장성, 기능에서 R 환경에서 타의 추종을 불허하는 기본 문자열 처리 R 팩키지

# * stringr --------------------------------------------
# 1. 문자열 매칭하기 ---------------------------------
hangul <- c("자동차", "한국", "한국산 자동차와 자동차 손수레")

# 자동차라는 단어가 포함되어 있으면 T
str_detect(string = hangul, pattern = "자동차")

# fixed("자동차") 
# 입력값 그대로의 문자로 매칭 시킴 => 정규식 패턴 무시할 때
str_detect(string = hangul, pattern = fixed("자동차"))

# 자동차가 있는 string 추출
str_subset(string = hangul, pattern = fixed("자동차"))

# 문자열 내 자동차라는 단어가 몇개 나오는지
str_count(string = hangul, pattern = fixed("자동차"))


# 2. 문자열 쪼개기 --------------------------------
hangul <- c("한국산 자동차와 손수레 그리고 오토바이")

# "그리고 " , "와" 라는 공백으로 문자열 쪼개기 
# 결과는 list형태
str_split(hangul, pattern = " 그리고 |와")

# n = 2를 주게되면 결과의 개수를 지정 
str_split(hangul, pattern = " 그리고 |와", n=2)


hanguls <- c("한국산 자동차와 손수레 그리고 오토바이",
             "독일산 자동차 그리고 아우토반")
# 결과는 list
str_split(hanguls, pattern = " 그리고 |와")

# simplify = TRUE 의 결과는 matrix형태
str_split(hanguls, pattern = " 그리고 |와", simplify = TRUE)

# list형태로 문자를 쪼개고
hanguls_split <- str_split(hanguls, pattern = " 그리고 |와")
# 각 list의 length를 반환 => lapply사용
lapply(hanguls_split, length)

# 3. 매칭된 문자열 치환 --------------------
# "와"라는 단어를 " 그리고"로 치환
str_replace_all(hanguls,
                pattern = "와",
                replacement = " 그리고")







# ************************** -----
# * 정규 표현식---------------------------
# 1. 들어가기에 앞서 tip ---------------
# 입력 문자열을 별도로 떼어내어 준비: 예를 들어, auto_v
# 정규식 패턴을 별도로 떼어내어 작성: 예를 들어, regex_pattern
# 문자열 작업에 맞는 함수를 선택: 예를 들어 문자열을 매칭하려면, str_detect()
# 입력 문자열과 문자열 작업에 맞는 함수를 선택하는 것은 상대적으로 변수가 많이 없는데 정규표현식 패턴을 작성하는 작업은 별도로 작성하는 것이 정신건강에 좋다. 특히, str_view() 함수를 사용하게 되면 패턴에 매칭된 결과를 시각적으로 빠르게 확인할 수 있다.

# 2. rebus 정규식 소개 -----------------
library(rebus)
# ^.\\d+ 정규표현식은 => 시작 하는 문자가 숫자 한번 또는 그 이상
# 다른 언어에서 ^.\d+와 같은 것으로 \ 한번 더 들어가는 것을 유의한다. 
# 의미는 ^ 시작한다 
# . 한 문자로 
# \\d 숫자 하나를 의미
# +가 있어 숫자를 다수 의미한다.

# 문자열 패턴	정규표현식	rebus
# 문자열 시작	^	START
# 문자열 끝	  $	END
# 임의 문자 하나	.	ANY_CHAR
# 또는(alternation)	|	or / or1
# 문자 클래스(character class)	[Aa]	char_class(“Aa”)
# 여문자 클래스	[^Aa]	negated_char_class(“Aa”)
# 선택옵션	?	optional()
# 0번 혹은 그 이상	*	zero_or_more()
# 1번 혹은 그 이상	+	one_or_more()
# n번에서 m번까지	{n}{m}	repeated()
# 숫자만	[0-9]	DGT 혹은 char_class(“0-9”)
# 단어	[a-zA-z0-9_]	WRD 혹은 char_class(“a-zA-z0-9_”)
# 화이트스페이스 문자	\s	SPC
# 한글	[가-흫]	char_class(“가-흫”)

# 2-1. 정규식 들어가며 -------------------------
auto_v <- c("1 자동차 1234", "12 Korean 자동차", "12한국산 자동차와 손수레", "2017년식 한국형")

# F T T T
regex_pattern <- "^.\\d+"
str_detect(auto_v, pattern = regex_pattern)

# "^.\\d+" 동일 의미
# 어떤 문자든 1번 혹은 그 이상의 숫자로 시작되는 패턴
# \\d+  \\d 숫자 + '+' 의 조합이므로 2개부터 찾음!
rebus_pattern <- START %R% 
  ANY_CHAR %R%
  one_or_more(DGT)

str_detect(auto_v, pattern = rebus_pattern)

# 일치되는 패턴을 따로 확인 가능
str_view(auto_v, pattern = rebus_pattern)

# 2-2. 한글 정규식 --------------------------
# 숫자(DGT), 단어(WRD), 화이트스페이스(SPC)와 같이 한글이 별도로 정의된 것이 없어 char_class 함수에 한글 정규표현식을 담아 사용한다. 
# 즉, 한글 한글자 추출 char_class("가-흫"), 
# 한글 단어 추출은 one_or_more(char_class("가-흫")) 표현식을 사용한다.

auto_v <- c("자동차", "Korean 자동차", "한국산 자동차와 손수레", "2017년식 한국형", "자 korea")

# 손수레를 찾아라!
regex_pattern <- fixed("손수레")
str_view(auto_v, pattern = regex_pattern)

# string에서 처음으로 나오는 한글 한글자를 찾아라!
hangul_pattern <- char_class("가-흫")
str_view(auto_v, pattern = hangul_pattern)

# string에서 처음으로 나오는 한글자 이상의 한글을 찾아라!
hangul_pattern <- one_or_more(char_class("가-흫"))
str_view(auto_v, pattern = hangul_pattern)

# string에서 처음으로 나오는 한글 4글자를 찾아라!!
hangul_pattern <- repeated(one_or_more(char_class("가-흫")), 4)
str_view(auto_v, pattern = hangul_pattern)


# 2-3. 포획(capture) - 돈관련! --------------------
# 금융에 가면 자주 쓸 듯 합니다 ^_^
# 포획(capture)을 잘 설명하는 예제는 달러의 달러부분과 센트 부분을 나누는 예제를 생각해볼 수 있다. 이런 경우 capture 함수를 사용해서 결과 값을 달러와 센트로 나눠 저장하여 분석한다.
# 달러 -------------------------------
money_v <- c("$7.47", "$73.67", "$37.56", "$37.564")

money_pattern <- DOLLAR %R%
  capture(DGT %R% optional(DGT)) %R%  
  # caputre(DGT) 만 주게되면 달러 다음 첫 번째 숫자만 찾음
  # %R% optional(DGT) 선택옵션 => 숫자 모두에 적용
  DOT %R%
  # .을 기준으로
  capture(dgt(2))
  # . 다음 숫자 두개를 포획하라!

str_match(money_v, pattern = money_pattern)

# 원화 ------------------------------
# 원화는 \u20A9로 표시를 하는 것 같아요.
# 위 예제와 동일하니 주석은 생략
kmoney_v <- c("\u20A97.47", "\u20A973.67", "\u20A937.56")

kmoney_pattern <- char_class("\u20A9") %R%
  capture(DGT %R% optional(DGT)) %R%
  DOT %R%
  capture(dgt(2))

str_match(kmoney_v, pattern = kmoney_pattern)


# 2-4. 역참조란? ------------------------------------
# 역참조는 중복된 것을 찾아낼 때 사용할 수 있다. 
# “자동차”가 두번 중복된 것을 찾아내고,
# 역참조 기능을 사용하여 str_replace 함수를 활용하여 공백으로 치환하여 제거한다.


# 2-4-1. 역참조하여 중복 찾아내기 -----------------------
auto_v <- c("자동차 한국", 
            "한국산 자동차 자동차와 손수레")

# auto_v <- c("자동차 자동차 자동차 한국", 
#             "한국산 자동차 자동차 자동차와 손수레")

str_view(auto_v,
         SPC %R% # 일단 공백을 찾고
         capture(one_or_more(char_class("가-흫"))) %R% 
           # 공백 뒤 한글문자를 포획
         SPC %R%
         REF1)  # REF1 만 사용가능 한듯 ... REF2는 에러가 뜨네요
         # 다음 공백 이후로 포획된 문자 처음으로 반복 되는 것을 찾아라

# 위 2가지 케이스를 비교해보시면 쉽게 확인 가능합니다.

# 2-4-2. 역참조하여 치환 -----------------------------
auto_v <- c("자동차 한국", 
            "한국산 자동차 자동차와 손수레")
str_replace(auto_v,
            SPC %R%
              capture(one_or_more(char_class("가-흫"))) %R%
              SPC %R%
              REF1, replacement = str_c(" ", REF1))


# 2-4-3. 정규표현식 대표 사례 ------------------------
# 전자우편 -------------------------
email_v <- c("email@example.com", "firstname.lastname@example.com", "email@subdomain.example.com", "이런건 안나와요", "영어도 안나오겠죠? adsf")
email_pattern <- "^[[:alnum:].-_]+@[[:alnum:].-]+$"

str_match(email_v, email_pattern)

# 전화번호 -------------------------
phone_v <- c("10.255.255.255", 
             "(777) 757 0221", 
             "Pick the phone at 751-525-1177",
             "567 Wall St",
             "유선전화: 577.665.2191 모바일: 888.777.0191")

separator <- char_class("-.() ")
phone_pattern <- capture(dgt(3)) %R% 
  zero_or_more(separator) %R% 
  capture(dgt(3)) %R% 
  zero_or_more(separator) %R%
  capture(dgt(4))

phone_numbers <- str_match(phone_v, phone_pattern)

str_c("(", phone_numbers[,2],
      ")", phone_numbers[,3],
      "-", phone_numbers[,4])
# 첫 번째 패턴만 인식하기 때문에 [5]의 모바일 번호는 패스
# ************************** -----
# 숫자를 문자로 변환  ------
# 데이터 분석 작업을 수행하는 경우 대부분 숫자를 다루게 되지만, 결국 숫자를 사람이 이해할 수 있고, 익숙한 형태로 변환을 해야한다. 예를 들어 천자리 넘어가는 숫자의 경우 , 콤마를 찍어 숫자에 대한 가독성을 높이거나 숫자의 소숫점, 환종에 대한 표현, 및 p-값 등을 표현할 때 숫자 서식(format)에 대한 처리가 최종 전달단계에서 중요하게 고려해야할 사항이 된다.

# 고려사항
# 소수점 처리
# 천단위를 넘는 정수
# p-값을 포함한 과학연산 숫자
# 환종(원화, 달러화, 엔화)을 표현한 숫자

# 유용한 함수들
# writeLines(): cat() 함수도 유사하지만 readLines()와 고려하여 일관성을 유지.
# formatC: format() 함수보다 일관되고 다양한 기능 제공
# format=“f” : 숫자를 있는 그대로 표현
# format=“e” : 숫자를 과학숫자 표현식으로 표현
# format=“g” : 가능하면 숫자를 있는 그대로 표현하지만, 
# 일정 자리수를 넘어가면 과학 표현식으로 전환, 특히 p-값 등을 표현할 때 유용함.
# paste(), paste0(): 문자와 숫자를 결합할 때 사용
# 인자로 collapse와 함께 사용


# 0. library -------------------------
library(rebus)
library(stringr)
library(stringi)

# 1. 데이터 -------------------------
p_value_v <- c(0.32, 0.99, 0.0000789, 0.00000000001)
percent_v  <- c(7, -7.97, 9.00, -1.002)
money_v <-  c(72.11, 871092.118, 7030.18, 27291.91, -234.4)


# 2. 숫자를 문자------------------------
# float 실수 형태로 소수 2째자리 까지
# int 정수 형태도 강제로 실수 형태로 보여줌
formatC(p_value_v, format="f", digits = 2)
formatC(percent_v, format="f", digits = 2)

# 숫자를 과학숫자 표현식? 뭘까요...
formatC(p_value_v, format="g", digits = 2)

# 천 단위 표시 / 기호 표시 
formatC(money_v, format = "f", digits = 1,
        big.mark = ",",  # 천 단위 , 표시
        flag="+") # default는 -만 => +기호 표시하고 싶을 때


# cat함수와 유사 => 결과를 한 줄씩 깔끔하게 표시
# jupyter로 보고서 작성할 때 용이할듯
writeLines(formatC(money_v, format = "f", digits = 1,
                   big.mark = ",", flag="+"))



# 3. 숫자에 표식 ------------------------
with_currency_v <- paste("\u20A9", money_v, sep="")

paste(percent_v, "%", sep="")
paste(with_currency_v, collapse=", ")           



# 4. 숫자표 생성 ------------------------
# 요것도 보고서 작성용
year_names_v <- c("2014년", "2015년", "2016년",
                  "2017년", "총합")

pretty_money_v <- formatC(money_v, digits=1,
                          big.mark=",", format="f")

korean_money <- paste("\u20A9", pretty_money_v, sep="")

formatted_names <- format(year_names_v, 
                          justify="centre") # justify = 정렬

rows <- paste(formatted_names, korean_money, sep="  ---  ")

writeLines(rows)
