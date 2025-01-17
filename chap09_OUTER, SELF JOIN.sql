-- OUTER JOIN 실습환경 세팅
INSERT INTO tb_dept VALUES ('100014', '4차산업혁명팀', '999999');
INSERT INTO tb_dept VALUES ('100015', '포스트코로나팀', '999999');
COMMIT;

SELECT * FROM tb_dept;

ALTER TABLE tb_emp DROP CONSTRAINT fk_tb_emp01;

INSERT INTO tb_emp (emp_no, emp_nm, birth_de, sex_cd, addr, tel_no, direct_manager_emp_no, 
                    final_edu_se_cd, sal_trans_bank_cd, sal_trans_accnt_no, dept_cd, lunar_yn)
VALUES ('1000000041', '이순신', '19811201', '1', '경기도 용인시 수지구 죽전1동 435', '010-5656-7878',
        NULL, '006', '003', '114-554-223433', '000000', 'N');

INSERT INTO tb_emp (emp_no, emp_nm, birth_de, sex_cd, addr, tel_no, direct_manager_emp_no, 
                    final_edu_se_cd, sal_trans_bank_cd, sal_trans_accnt_no, dept_cd, lunar_yn)
VALUES ('1000000042', '정약용', '19820402', '1', '경기도 고양시 덕양구 화정동 231', '010-4054-6547',
        NULL, '004', '001', '110-223-553453', '000000', 'Y');

INSERT INTO tb_emp (emp_no, emp_nm, birth_de, sex_cd, addr, tel_no, direct_manager_emp_no, 
                    final_edu_se_cd, sal_trans_bank_cd, sal_trans_accnt_no, dept_cd, lunar_yn)
VALUES ('1000000043', '박지원', '19850611', '1', '경기도 수원시 팔달구 매탄동 553', '010-1254-1116',
        NULL, '004', '001', '100-233-664234', '000000', 'N');
        
INSERT INTO tb_emp (emp_no, emp_nm, birth_de, sex_cd, addr, tel_no, direct_manager_emp_no, 
            final_edu_se_cd, sal_trans_bank_cd, sal_trans_accnt_no, dept_cd, lunar_yn)
VALUES ('1000000044', '장보고', '19870102', '1', '경기도 성남시 분당구 정자동 776', '010-1215-8784',
        NULL, '004', '002', '180-345-556634', '000000', 'Y');
        
INSERT INTO tb_emp (emp_no, emp_nm, birth_de, sex_cd, addr, tel_no, direct_manager_emp_no, 
            final_edu_se_cd, sal_trans_bank_cd, sal_trans_accnt_no, dept_cd, lunar_yn)
VALUES ('1000000045', '김종서', '19880824', '1', '경기도 고양시 일산서구 백석동 474', '010-3687-1245',
        NULL, '004', '002', '325-344-45345', '000000', 'Y');
        
COMMIT;

-- 사원정보 조회 + 부서정보 조회
SELECT
    E.emp_no
    , E.emp_nm
    , E.dept_cd
    , D.dept_nm
FROM tb_emp E
JOIN tb_dept D
ON E.dept_cd = D.dept_cd
;

-- # OUTER JOIN
-- 1. 조인 조건을 만족하지 않는 행들도 조회할 때 사용하는 조인기법입니다.
-- 2. OUTER조인 연산자 기호는 (+)기호입니다.
-- 3. INNER조인은 조인 조건을 만족하지 않으면 해당 행을 조회하지 않습니다
--   그러나 OUTER JOIN은 방향(LEFT, RIGHT, FULL)에 맞게 조건에 매칭되지 
--   않는 행들도 모두 NULL로 처리해서 조회합니다.

-- # LEFT OUTER JOIN
-- 조인되는 왼쪽 테이블은 모두 조회하고, 오른쪽 테이블은 조인조건에 매칭된 것만 조회합니다.

-- 나는 사원정보는 일단 다 보고 싶은데 혹시 부서테이블에서 부서코드가 매칭되면
-- 보너스로 부서이름도 찍어줘라

-- LEFT JOIN
SELECT E.emp_no
    , E.emp_nm
    , E.dept_cd
--    , D.dept_cd --부서 정보 없어서 null로 조회됨
    , D.*
FROM tb_emp E
--INNER JOIN tb_dept D --신입사원 조회X
LEFT OUTER JOIN tb_dept D
ON E.dept_cd = D.dept_cd
;

-- RIGHT JOIN
SELECT E.emp_no
    , E.emp_nm
    , E.dept_cd
--    , D.dept_cd --부서 정보 없어서 null로 조회됨
    , D.*
FROM tb_emp E
--INNER JOIN tb_dept D --신입사원 조회X
RIGHT OUTER JOIN tb_dept D
ON E.dept_cd = D.dept_cd
;

-- 사원이 46명, 부서가 16개
-- 부서에 소속된 사원이 41명
-- 사원이 존재하는 부서 14개
-- INNER JOIN의 결과 사원정보조회 41건
-- LEFT JOIN : INNER 41 + 부서가없는 사원 5 = 46건
-- RIGHT JOIN :INNER 41 + 사원이없는 부서 2  = 43건
-- FULL JOIN : INNER 41 + 5 + 2 = 48건

-- FULL OUTER
SELECT E.emp_no
    , E.emp_nm
    , E.dept_cd
--    , D.dept_cd --부서 정보 없어서 null로 조회됨
    , D.*
FROM tb_emp E
--INNER JOIN tb_dept D --신입사원 조회X
FULL OUTER JOIN tb_dept D
ON E.dept_cd = D.dept_cd
;

-- 오라클 조인
-- LEFT: 조인조건에서 오른쪽에 (+)를 붙임
-- RIGHT: 조인조건에서 왼쪽에 (+)를 붙임
-- FULL: 지원하지 않음
-- (+)가 붙으면 표준조인에서 ON절에 위치하는 조건

SELECT
    E.emp_no
    , E.emp_nm
    , E.dept_cd
    , D.dept_nm
FROM tb_emp E, tb_dept D
WHERE E.dept_cd = D.dept_cd (+)
;

SELECT
    E.emp_no
    , E.emp_nm
    , E.dept_cd
    , D.dept_nm
FROM tb_emp E, tb_dept D
WHERE E.dept_cd (+) = D.dept_cd 
;

-- # SELF JOIN
-- 1. 하나의 테이블에서 자기 자신의 테이블끼리 조인하는 기법입니다.
-- 2. 자기 자신 테이블에서 pk와 fk로 동등조인합니다.

SELECT 
    A.emp_no "사원번호"
    , A.emp_nm "사원명"
    , A.addr "사원의 주소"
    , A.direct_manager_emp_no "상사 사번"
    , NVL(B.emp_nm, '상사없음') "상사명"
FROM tb_emp A
LEFT OUTER JOIN tb_emp B
ON A.direct_manager_emp_no = B.emp_no
;