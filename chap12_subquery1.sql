-- 단일 행 서브쿼리
-- 서브쿼리의 조회결과가 0건 또는 1건인 서브쿼리

-- 부서코드가 100004번인 부서의 사원정보 조회
SELECT 
    emp_no
    , emp_nm
    , dept_cd
FROM tb_emp
WHERE dept_cd = '100004'
;

-- 이나라가 속한 부서의 전체 사원정보를 조회
SELECT 
  dept_cd
FROM tb_emp
WHERE emp_nm = '이나라'
;

SELECT 
    emp_no
    , emp_nm
    , dept_cd
FROM tb_emp
WHERE dept_cd = (
            SELECT 
              dept_cd
            FROM tb_emp
            WHERE emp_nm = '이나라'
)
;

/*
    사원이름이 이관심인 사람이 2명이므로
    이 서브쿼리에서는 단일행이 아닌 다중행이 리턴됨
    따라서 단일행 연산자인 (=, <, <=, >, >=, !=, <>)를 사용할 수 없음
*/
SELECT 
    emp_no
    , emp_nm
    , dept_cd
FROM tb_emp
WHERE dept_cd = (
            SELECT 
              dept_cd
            FROM tb_emp
            WHERE emp_nm = '이관심'
)
;

-- 20200525에 받은 급여액수가 회사 전체의
-- 20200525일 전체 평균 급여보다 높은 사원들의 정보
-- (사번, 이름, 급여지급일, 받은급여액수) 를 조회
SELECT
    E.emp_no
    , E.emp_nm
    , H.pay_de
    , H.pay_amt
FROM tb_emp E
LEFT JOIN tb_sal_his H
ON E.emp_no = H.emp_no
WHERE H.pay_de = '20200525'
    AND H.pay_amt >= (
                    SELECT AVG(pay_amt)
                    FROM tb_sal_his
                    WHERE pay_de = '20200525'
)
ORDER BY E.emp_no
;

-- # 다중행 서브쿼리
-- 서브쿼리의 조회 건수가 0건 이상인 것
-- ## 다중행 연산자
-- 1. IN : 메인쿼리의 비교조건이 서브쿼리 결과중에 하나라도 일치하면 참
--    ex )  salary IN (200, 300, 400)
--            250 ->  200, 300, 400 중에 없으므로 false
-- 2. ANY, SOME : 메인쿼리의 비교조건이 서브쿼리의 검색결과 중 하나 이상 일치하면 참
--    ex )  salary > ANY (200, 300, 400)
--            250 ->  200보다 크므로 true
-- 3. ALL : 메인쿼리의 비교조건이 서브쿼리의 검색결과와 모두 일치하면 참
--    ex )  salary > ALL (200, 300, 400)
--            250 ->  200보다는 크지만 300, 400보다는 크지 않으므로 false
-- 4. EXISTS : 메인쿼리의 비교조건이 서브쿼리의 결과 중 
--				만족하는 값이 하나라도 존재하면 참

-- 한국데이터베이스진흥원에서 발급한 자격증을 가지고 있는
-- 사원의 사원번호와 사원이름과 해당 사원의 한국데이터베이스진흥원에서 
-- 발급한 자격증 개수를 조회

SELECT
    E.emp_no, E.emp_nm
    , COUNT(EC.certi_cd) AS count
FROM tb_emp E
JOIN tb_emp_certi EC
ON E.emp_no = EC.emp_no
WHERE certi_cd IN (
                    SELECT 
                    certi_cd
                    FROM tb_certi
                    WHERE issue_insti_nm = '한국데이터베이스진흥원'
                    )
GROUP BY E.emp_no, E.emp_nm
;

SELECT 
    certi_cd
FROM tb_certi
WHERE issue_insti_nm = '한국데이터베이스진흥원'
;