--Fraga.sql
--Created by Jose Fraga on April 22, 2018
--Execute in SQL>
--SET SERVEROUTPUT ON
--@Fraga.sql to run
--Write a PL/SQL (Procedural Language/SQL) procedure that performs the following tasks
--in order to insert a record into the Trip table.
DECLARE
    --<Declaration statements>
    --VariableName[CONSTANT]dataType[NOT NULL][:=PL/SQL expression];
    --Task 1
    --The procedure accepts values for Emp_ID, To_City, Dep_Date, Return_Date, and Est_Cost attributes.
    inputEmp_ID INTEGER;
    inputTo_City CHAR(15);
    inDep_Date DATE;
    inReturn_Date DATE;
    inputEst_Cost DECIMAL(6,2);
    newID INTEGER;
    CURSOR cursorEmp_ID IS SELECT Emp_ID FROM Trip WHERE Emp_ID IN(SELECT ID FROM Employee WHERE Emp_ID = ID);
    fetchCursorEmp_ID INTEGER;
    foundEmp_ID BOOLEAN := FALSE;
    bound INTEGER;
    counter INTEGER := 0;
BEGIN
    --<Executable statements>
    --User input
    inputEmp_ID := &inputEmp_ID;
    inputTo_City := '&inputTo_City';
    inDep_Date := '&inDep_Date';
    inReturn_Date := '&inReturn_Date';
    inputEst_Cost := &inputEst_Cost;
    --Task 2
    --It then checks to see if the Emp_ID value is valid(i.e. the value exists in the Employee table).
    SELECT COUNT(ID) INTO bound FROM Employee;
    OPEN cursorEmp_ID;
    LOOP
        FETCH cursorEmp_ID INTO fetchCursorEmp_ID;
        IF (fetchCursorEmp_ID = inputEmp_ID) THEN
            foundEmp_ID := TRUE;
            EXIT;
        END IF;
        counter := counter + 1;
        EXIT WHEN counter > bound;
    END LOOP;
    CLOSE cursorEmp_ID;
    IF (foundEmp_ID = TRUE) THEN
        --Task 3
        --Check to ensure the return date is not before the departure date. Else, print appropriate
        --message and quit.
        IF (inReturn_Date >= inDep_Date) THEN
            --Task 4
            --Check to ensure the estimated cost is within the acceptable range (see schema).
            --Else, print appropriate message and quit.
            IF (inputEst_Cost >= 1.00 AND inputEst_Cost <= 4000.00) THEN
                --Task 5
                --Compute value of the ID attribute by adding one to the maximum ID
                --value that exists in Trip table.
                SELECT MAX(ID) + 1 INTO newID FROM Trip;
                DBMS_OUTPUT.PUT_LINE('DBMS_OUTPUT: newID = ' || newID);
                DBMS_OUTPUT.PUT_LINE('DBMS_OUTPUT: inputEmp_ID = ' || inputEmp_ID);
                DBMS_OUTPUT.PUT_LINE('DBMS_OUTPUT: inputTo_City = ' || inputTo_City);
                DBMS_OUTPUT.PUT_LINE('DBMS_OUTPUT: inputDep_Date = ' || inDep_Date);
                DBMS_OUTPUT.PUT_LINE('DBMS_OUTPUT: inputReturn_Date = ' || inReturn_Date);
                DBMS_OUTPUT.PUT_LINE('DBMS_OUTPUT: inputEst_Cost = ' || inputEst_Cost);
                --Insert the record into the Trip table
                INSERT INTO Trip(ID,Emp_ID,To_City,Dep_Date,Return_Date,Est_Cost) VALUES(newID,inputEmp_ID,inputTo_City,inDep_Date,inReturn_Date,inputEst_Cost);
                --Print message
                DBMS_OUTPUT.PUT_LINE('DBMS_OUTPUT: Successful addition of the record.');
            ELSE
                DBMS_OUTPUT.PUT_LINE('DBMS_OUTPUT:inputEst_Cost value is not valid. Unsuccessful addition of the record.');
            END IF;
        ELSE
            DBMS_OUTPUT.PUT_LINE('DBMS_OUTPUT:inReturn_Date value is not valid. Unsuccessful addition of the record.');
        END IF;
    ELSE
        DBMS_OUTPUT.PUT_LINE('DBMS_OUTPUT:inputEmp_ID value is not valid. Unsuccessful addition of the record.');
    END IF;
END;
/
