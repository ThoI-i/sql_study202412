
SELECT * FROM tb_sal_his;

-- 집계 함수 (다중행 함수)
-- 여러 행을 묶어서 한번에 함수를 적용
SELECT
    COUNT(*) "지급 횟수",
    SUM(pay_amt) "지급 총액",
    AVG(pay_amt) "평균 지급액",
    MIN(pay_amt) "최대 지급액",
    MAX(pay_amt) "최소 지급액"
FROM tb_sal_his
;

-- 집계함수는 처리시 null을 무시함
SELECT 
    COUNT(direct_manager_emp_no)
FROM tb_emp
;

SELECT 
    COUNT(*)
FROM tb_emp
WHERE emp_nm LIKE '김%'
;

SELECT
    MIN(birth_de) "최연장자 생일",
    MAX(birth_de) "최연소자 생일"
FROM tb_emp
;

-- 총 사원수 말고 부서별 사원수를 집계
-- 회사 전체의 연장자 생일말고 부서별로 연장자 생일을 알고 싶음
-- GROUP BY
-- 각 그룹별로 집계함수를 각각 적용

SELECT 
    emp_no,
    emp_nm,
    birth_de,
    dept_cd
FROM tb_emp
ORDER BY dept_cd
;

SELECT
    dept_cd,
    COUNT(*) "부서별 인원 수",
    MIN(birth_de) "부서별 최연장자 생일"
FROM tb_emp
GROUP BY dept_cd
ORDER BY dept_cd
;

SELECT
    emp_no,
    TO_CHAR(SUM(pay_amt), 'L999,999,999') "사원별 총급여액",
    TO_CHAR(ROUND(AVG(pay_amt), 2), 'L999,999,999.99') "사원별 급여평균",
    COUNT(*) "사원별 지급 횟수",
    TO_CHAR(MAX(pay_amt), 'L999,999,999') "최고 수령액"
FROM tb_sal_his
GROUP BY emp_no
ORDER BY emp_no
;


CREATE TABLE TABLE_A27 (
    TABKEY NUMBER(3) PRIMARY KEY,
    COLA NUMBER(3),
    COLB VARCHAR2(3),
    COLC NUMBER(3)
);

INSERT INTO TABLE_A27
VALUES (1, null, '가', null);

INSERT INTO TABLE_A27
VALUES (2, 1, '가', 5);

INSERT INTO TABLE_A27
VALUES (3, null, '나', 2);

INSERT INTO TABLE_A27
VALUES (4, 3, '나', 0);

INSERT INTO TABLE_A27
VALUES (5, null, null, 3);

INSERT INTO TABLE_A27
VALUES (6, 5, '다', 0);

INSERT INTO TABLE_A27
VALUES (7, null, '다', null);


SELECT 
    COLB,
    MAX(COLA),
    MIN(COLA),
    SUM(COLA + COLC)
FROM TABLE_A27
GROUP BY COLB;



SELECT 
    emp_no
    , emp_nm
    , dept_cd
    , COUNT(*)
FROM tb_emp
;


SELECT 
    emp_no
FROM tb_emp;

SELECT 
    COUNT(*)
FROM tb_emp;

-- GROUP BY절에서 사용한 컬럼만 다이렉트로 SELECT에서 사용가능
-- 그 이외 컬럼은 집계함수를 사용하지 않으면 사용 불가
SELECT 
    dept_cd,
    COUNT(*)
FROM tb_emp
GROUP BY dept_cd
;

SELECT 
    dept_cd,
    sex_cd,
    COUNT(*)
FROM tb_emp
GROUP BY sex_cd, dept_cd
ORDER BY dept_cd
;


-- 급여 이력 테이블에서 
-- 사원별로 2019년에 발생한
-- 급여 평균액, 최소지급액, 최대지급액 조회

-- WHERE : 집계 전 필터링
SELECT 
    emp_no
    , AVG(pay_amt)
    , MIN(pay_amt)
    , MAX(pay_amt)
FROM tb_sal_his
WHERE pay_de BETWEEN '20190101' AND '20191231'
GROUP BY emp_no
ORDER BY emp_no
;

-- 급여 이력 테이블에서 
-- 평균급여가 400만원 이상인 
-- 사원들의 급여총액과 급여평균을 조회

-- HAVING : 집계 후 필터링
SELECT 
    emp_no
    , SUM(pay_amt)
    , AVG(pay_amt)
FROM tb_sal_his
WHERE pay_de BETWEEN '20190101' AND '20191231'
GROUP BY emp_no
HAVING AVG(pay_amt) >= 4500000
;

-- 부서별로 가장 어린사람의 생년월일, 연장자의 생년월일, 부서별 총 사원 수를 조회
-- 그런데 부서별 사원이 1명인 부서의 정보는 조회하고 싶지 않음.

SELECT 
    dept_cd AS dc,
    MAX(birth_de),
    MIN(birth_de),
    COUNT(*) cnt
FROM tb_emp
GROUP BY dept_cd
HAVING COUNT(*) > 1
ORDER BY dept_cd
;