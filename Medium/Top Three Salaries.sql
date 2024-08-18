/*
As part of an ongoing analysis of salary distribution within the company, your manager has requested a report identifying high earners in each department. A 'high earner' within a department is defined as an employee with a salary ranking among the top three salaries within that department.

You're tasked with identifying these high earners across all departments. Write a query to display the employee's name along with their department name and salary. In case of duplicates, sort the results of department name in ascending order, then by salary in descending order. If multiple employees have the same salary, then order them alphabetically.

Note: Ensure to utilize the appropriate ranking window function to handle duplicate salaries effectively.

As of June 18th, we have removed the requirement for unique salaries and revised the sorting order for the results.

employee Schema:
column_name	type	description
employee_id	integer	The unique ID of the employee.
name	string	The name of the employee.
salary	integer	The salary of the employee.
department_id	integer	The department ID of the employee.
manager_id	integer	The manager ID of the employee.
employee Example Input:
employee_id	name	salary	department_id	manager_id
1	Emma Thompson	3800	1	6
2	Daniel Rodriguez	2230	1	7
3	Olivia Smith	2000	1	8
4	Noah Johnson	6800	2	9
5	Sophia Martinez	1750	1	11
6	Liam Brown	13000	3	
7	Ava Garcia	12500	3	
8	William Davis	6800	2	
9	Isabella Wilson	11000	3	
10	James Anderson	4000	1	11
department Schema:
column_name	type	description
department_id	integer	The department ID of the employee.
department_name	string	The name of the department.
department Example Input:
department_id	department_name
1	Data Analytics
2	Data Science
*/
SELECT department_name, name, salary 
  from (
        SELECT d.department_name department_name, e.name name, e.salary salary, 
        DENSE_RANK() OVER(PARTITION BY d.department_id ORDER BY e.salary DESC) as rn 
        from employee e  
        INNER JOIN department d  
        ON e.department_id= d.department_id
      ) c 
  where rn <= 3
ORDER BY department_name, salary DESC, name;
