# SammanResorts Database README

## Overview

The `SammanResorts` database is designed for managing a chain of resorts, handling operations including room bookings, service bookings, and various resort facilities. This schema supports the creation of branches, management of employees and customers, and recording of financial transactions related to room and service bookings.

## Schema Overview

### Tables

1. **Branches**: Contains information about each resort branch.
   - `Branch_ID`: Unique identifier for the branch.
   - `Branch_Name`: Name of the branch.
   - `Location`: Physical location of the branch.
   - `Operation_Status`: Indicates if the branch is operational (TRUE/FALSE).
   - `Number_of_Rooms`: Total number of rooms in the branch.
   - `Branch_Head`: Employee responsible for the branch.

2. **Customer**: Stores details of customers.
   - `Customer_ID`: Unique identifier for the customer.
   - `Sex`: Gender of the customer ('M' or 'F').
   - `DOB`: Date of Birth.
   - `Customer_Type`: Type of customer ('Guest' or 'Visitor').
   - `First_Name`, `Last_Name`: Customer’s first and last names.
   - `Email`: Customer’s email (unique).
   - `Phone_Number`: Contact number.

3. **Department**: Lists departments within the resorts.
   - `Department_ID`: Unique identifier for the department.
   - `Department_Name`: Name of the department.
   - `Department_Head`: Employee managing the department.

4. **Employee**: Records employee details.
   - `Employee_ID`: Unique identifier for the employee.
   - `First_Name`, `Last_Name`: Employee’s first and last names.
   - `Sex`: Gender ('M' or 'F').
   - `DOB`: Date of Birth.
   - `Date_of_Employment`: Date when the employee was hired.
   - `Branch_ID`: The branch where the employee works.
   - `Department_ID`: Department the employee belongs to.
   - `Position`: Job title.
   - `Home_Address`, `Email`, `Phone_Number`: Contact details.

5. **Room**: Information about rooms available in each branch.
   - `Room_ID`: Unique identifier for the room.
   - `Room_Name`: Name or type of the room.
   - `Room_Type`: Type of room ('Single', 'Double', 'Suite', 'Presidential').
   - `Price`: Cost of the room.
   - `Room_Status`: Availability status (TRUE/FALSE).
   - `Branch_ID`: The branch where the room is located.

6. **Facilities**: Details of facilities available at each branch.
   - `Facility_ID`: Unique identifier for the facility.
   - `Facility_Name`: Name of the facility.
   - `Branch_ID`: The branch where the facility is located.
   - `Facility_Head`: Employee responsible for the facility.

7. **Service**: Services offered at the resorts.
   - `Service_ID`: Unique identifier for the service.
   - `Service_Name`: Name of the service.
   - `Price`: Cost of the service.
   - `Facility_ID`: The facility where the service is provided.

8. **Room_Booking**: Records of room bookings.
   - `Room_Booking_ID`: Unique identifier for the booking.
   - `Customer_ID`: ID of the customer making the booking.
   - `Room_ID`: Room being booked.
   - `Check_In_Date`, `Check_Out_Date`: Dates for the booking.
   - `Requests`: Special requests made by the customer.

9. **Service_Booking**: Records of service bookings.
   - `Service_Booking_ID`: Unique identifier for the service booking.
   - `Service_ID`: ID of the service being booked.
   - `Price`: Cost of the service.
   - `Customer_ID`: ID of the customer.
   - `Employee_ID`: ID of the employee providing the service.
   - `Check_In_Time`, `Check_Out_Time`: Times for the service.
   - `Branch_ID`: Branch where the service is provided.
   - `Requests`: Special requests made by the customer.

10. **Room_Billing**: Billing details for room bookings.
    - `RBilling_ID`: Unique identifier for the billing record.
    - `Room_Booking_ID`: ID of the room booking.
    - `Payment_Status`: Status of payment ('Paid' or 'Pending').
    - `Payment_Date`: Date of payment.
    - `Payment_Method`: Method of payment.

11. **Service_Billing**: Billing details for service bookings.
    - `SBilling_ID`: Unique identifier for the billing record.
    - `Service_Booking_ID`: ID of the service booking.
    - `Price`: Cost of the service.
    - `Payment_Status`: Status of payment ('Paid' or 'Pending').
    - `Payment_Date`: Date of payment.
    - `Payment_Method`: Method of payment.

## Queries

### Checking Bookings

1. **Unbooked Rooms**
   ```sql
   SELECT Room_ID, Room_Name, Room_Type, Price AS Unbooked_Rooms
   FROM Room
   WHERE Room_Status=FALSE;
   ```

2. **Booked Rooms**
   ```sql
   WITH RoomBookings AS (
       SELECT 
           Room.Room_ID, 
           Room.Room_Name, 
           Room.Room_Type, 
           Room_Booking.Room_Booking_ID, 
           Room_Booking.Customer_ID, 
           Room_Booking.Check_In_Date, 
           Room_Booking.Check_Out_Date AS Booked_Rooms
       FROM 
           Room
       LEFT JOIN 
           Room_Booking ON Room.Room_ID = Room_Booking.Room_ID
       WHERE 
           Room.Room_Status = TRUE
   )
   SELECT 
       Room_ID, 
       Room_Name, 
       Room_Type, 
       Room_Booking_ID, 
       Customer_ID, 
       Check_In_Date, 
       Booked_Rooms
   FROM 
       RoomBookings
   UNION
   SELECT 
       NULL AS Room_ID, 
       NULL AS Room_Name, 
       NULL AS Room_Type, 
       NULL AS Room_Booking_ID, 
       NULL AS Customer_ID, 
       NULL AS Check_In_Date, 
       Room_Booking.Check_Out_Date AS Booked_Rooms
   FROM 
       Room_Booking
   RIGHT JOIN 
       Room ON Room.Room_ID = Room_Booking.Room_ID;
   ```

## Indexes

Indexes are created to improve performance on frequently queried fields:
- `idx_room_booking`: Index on `Customer_ID`, `Room_ID` in `Room_Booking`.
- `idx_service_booking`: Index on `Service_ID` in `Service_Booking`.
- `idx_room_billing`: Index on `Room_Booking_ID` in `Room_Billing`.
- `idx_customer_email`: Index on `Email` in `Customer`.
- `idx_room_price`: Index on `Price` in `Room`.
- `idx_service_price`: Index on `Price` in `Service`.

## Foreign Key Constraints

Foreign key constraints are added to maintain referential integrity across tables, ensuring data consistency when records are updated or deleted.

## Notes

- Ensure all required tables are created before populating data.
- Verify foreign key relationships and constraints to avoid conflicts.
- The database schema is designed to be scalable and maintainable for managing resort operations efficiently.

For any additional queries or issues, please contact the database administrator.
