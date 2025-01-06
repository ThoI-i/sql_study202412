SELECT
    emp_no
    , direct_manager_emp_no
FROM tb_emp
;

-- 계층형 쿼리 
-- START WITH : 계층의 첫 단계를 어디서 시작할 것인지의 대한 조건
-- CONNECT BY PRIOR 자식 = 부모  -> 순방향 탐색
-- CONNECT BY 자식 = PRIOR 부모  -> 역방향 탐색
-- ORDER SIBLINGS BY : 같은 레벨끼리의 정렬을 정함.
SELECT 
    LEVEL AS LVL,
    LPAD(' ', 4*(LEVEL-1)) || emp_no || '(' || emp_nm || ')' AS "조직인원",
    A.dept_cd,
    B.dept_nm,
    A.emp_no,
    A.direct_manager_emp_no,
    CONNECT_BY_ISLEAF -- 해당 행이 말단(끝)인지 확인(0이면 자식 O / 1이면 자식 X)
FROM tb_emp A
JOIN tb_dept B
ON A.dept_cd = B.dept_cd
START WITH A.direct_manager_emp_no IS NULL --LEVEL 1을 결정하는 것
--START WITH A.emp_no = 1000000001 -- START WITH --어디서부터 전개할거냐
--START WITH A.emp_no = 1000000010 -- START WITH --어디서부터 전개할거냐
CONNECT BY PRIOR A.emp_no = A.direct_manager_emp_no -- 순방향
--START WITH A.emp_no = 1000000040 -- START WITH --어디서부터 전개할거냐(역방향용)
--CONNECT BY A.emp_no = PRIOR A.direct_manager_emp_no --역방향
ORDER SIBLINGS BY A.emp_no DESC -- 같은 레벨끼리는 어떻게 정렬할 지
;
