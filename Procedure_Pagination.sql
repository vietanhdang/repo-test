CREATE DEFINER = 'root'@'localhost'
PROCEDURE `misa.web08.tcdn.dva.distribution`.Proc_Employee_GetPaging(IN v_Offset int, IN v_Limit int, IN v_Sort varchar(100), IN v_Where varchar(1000))
  COMMENT 'L?y danh s�ch nh�n vi�n v� t?ng s? nh�n vi�n c� ph�n trang'
BEGIN
  -- =============================================
  -- Author:       ANHDV
  -- Created date:  15/09/2022
  -- Description:   L?y danh s�ch nh�n vi�n v� t?ng s? nh�n vi�n c� ph�n trang
  -- Modified by:   
  -- Code ch?y th?: CALL Proc_Employee_GetPaging(0,10,'','')
  -- =============================================

  -- Ki?m tra n?u tham s? d?u v�o $Where b? NULL --> g�n gi� tr? cho v_Where = ''
  -- SELECT * FROM employee WHERE 1=1;
  IF IFNULL(v_Where, '') = '' THEN
    SET v_Where = '1=1';
  END IF;

  -- Ki?m tra n?u tham s? d?u v�o v_Sort b? NULL --> g�n gi� tr? cho v_Sort = ''
  -- SELECT * FROM employee WHERE 1=1 ORDER BY ModifiedDate DESC;
  IF IFNULL(v_Sort, '') = '' THEN
    SET v_Sort = 'ModifiedDate DESC';
  END IF;

  IF v_Limit = -1 THEN  -- L?y t?t c? d? li?u n?u v_Limit = -1
    SET @filterQuery = CONCAT('SELECT * FROM employee WHERE ', v_Where, ' ORDER BY ', v_Sort);
  ELSE
    SET @filterQuery = CONCAT('SELECT * FROM employee WHERE ', v_Where, ' ORDER BY ', v_Sort, ' LIMIT ', v_Offset, ',', v_Limit);
  END IF;

  -- @filterQuery l� 1 bi?n c� ki?u d? li?u l� string
  -- filterX l� 1 statement
  PREPARE filterQuery FROM @filterQuery;
  EXECUTE filterQuery;
  DEALLOCATE PREPARE filterQuery;

  -- L?y ra t?ng s? b?n ghi th?a m�n di?u ki?n l?c
  SET @filterQuery = CONCAT('SELECT count(EmployeeID) AS TotalCount FROM employee WHERE ', v_Where);
  PREPARE filterQuery FROM @filterQuery;
  EXECUTE filterQuery;
  DEALLOCATE PREPARE filterQuery;
END