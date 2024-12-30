SELECT
    emp_no
    , emp_nm
    , dept_cd
FROM tb_emp
;

SELECT 
    *
FROM tb_dept
;


-- 조인 기초 테스트 데이터
CREATE TABLE TEST_A (
    id NUMBER(10) PRIMARY KEY
    , content VARCHAR2(200)
);
CREATE TABLE TEST_B (
    b_id NUMBER(10) PRIMARY KEY
    , reply VARCHAR2(100)
    , a_id NUMBER(10)
);

INSERT INTO TEST_A  VALUES (1, 'aaa');
INSERT INTO TEST_A  VALUES (2, 'bbb');
INSERT INTO TEST_A  VALUES (3, 'ccc');

INSERT INTO TEST_B  VALUES (1, 'ㄱㄱㄱ', 1);
INSERT INTO TEST_B  VALUES (2, 'ㄴㄴㄴ', 1);
INSERT INTO TEST_B  VALUES (3, 'ㄷㄷㄷ', 2);
INSERT INTO TEST_B  VALUES (4, 'ㄹㄹㄹ', 3);

SELECT * FROM test_a;
SELECT * FROM test_b;

-- 조인의 기본 원리 곱연산 (중첩반복문개념)
-- 카테시안 곱 (Cartesian production)
-- 가능한 모든 경우의 수를 매칭하여 조회
SELECT *
FROM test_a, test_b
WHERE test_a.id = test_b.a_id
;

SELECT * 
FROM tb_emp, tb_dept
;

-- INNER JOIN
-- 두 테이블 간에 연관관계 매칭 컬럼을 이요하여
-- 관계가 있는 데이터를 매칭해서 필터링하여 조회

SELECT 
    tb_emp.emp_no
    , tb_emp.emp_nm
    , tb_emp.dept_cd
    , tb_dept.dept_cd
    , tb_dept.dept_nm
FROM tb_emp, tb_dept
WHERE tb_emp.dept_cd = tb_dept.dept_cd
;

-- 테이블 간략화
SELECT 
    E.emp_no
    , E.emp_nm
    , E.dept_cd
    , D.dept_cd
    , D.dept_nm
FROM tb_emp E, tb_dept D
WHERE E.dept_cd = D.dept_cd
;

-- 사원의 사원번호와 사원명과 취득한 자격증명을 조회
SELECT
    E.emp_no
    , E.emp_nm
FROM tb_emp E
;

-- 중간(매개) 테이블
SELECT
    EC.emp_no
    , EC.certi_cd
    , EC.acqu_de
FROM tb_emp_certi EC
;

-- 자격증 정보 테이블
SELECT
    *
FROM tb_certi C
;

-- 자격증 보유 + 자격증 명 추가
SELECT
    E.emp_no
    , E.emp_nm
    , EC.acqu_de
    , EC.certi_cd
    , C.certi_nm -- 자격증 명 확인
FROM tb_emp E, tb_emp_certi EC
, tb_certi C -- 자격증 명 확인
WHERE E.emp_no = EC.emp_no
    AND EC.certi_cd = C.certi_cd -- 자격증 명 확인
;


SELECT
    E.emp_no
    , E.emp_nm
    , EC.acqu_de
    , EC.certi_cd
    , C.certi_nm -- 자격증 명 확인
FROM tb_emp E, tb_emp_certi EC
, tb_certi C -- 자격증 명 확인
WHERE E.emp_no = EC.emp_no
    AND EC.certi_cd = C.certi_cd -- 자격증 명 확인
;


-- 부서 명 추가
SELECT 
    E.emp_no
    , E.emp_nm
    , EC.acqu_de
    , EC.certi_cd
    , C.certi_nm
    , E.dept_cd
    , D.dept_nm
FROM tb_emp E, tb_emp_certi EC, tb_certi C, tb_dept D
WHERE E.emp_no = EC.emp_no
      AND EC.certi_cd = C.certi_cd
      AND E.dept_cd = D.dept_cd
;
