DROP PROCEDURE IF EXISTS spMyProc;
DELIMITER //

CREATE PROCEDURE spMyProc(
  IN startDate VARCHAR(255),
	IN endDate VARCHAR(255),
	IN period INT(3),
	IN year VARCHAR(255)
)
BEGIN
  DECLARE exit handler for SQLEXCEPTION
    BEGIN
    SHOW ERRORS;
    ROLLBACK;
  END;
  DECLARE exit handler for SQLWARNING
    BEGIN
    SHOW ERRORS;
    ROLLBACK;
  END;
  
  START TRANSACTION;
  
  UPDATE
    time_entries
  SET
    basic_pay = null,
    holiday_pay = null,
    basic_pay_status = null,
    holiday_pay_status = null
  WHERE
    date(updated_at) between @startDate and @endDate;

  DELETE FROM
    payruns
  WHERE
    period = @period
    and year(created_at) = @year;

  COMMIT;
END //
DELIMITER ;

CALL spMyProc(@startDate,@endDate,@period,@year);
DROP PROCEDURE spMyProc;


-- SELECT @startDate, @endDate, @period, @year;