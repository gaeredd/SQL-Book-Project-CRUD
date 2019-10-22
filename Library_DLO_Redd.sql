Create trigger trgUpdateNumberOfCopiesOwnedForNewCopy --the trigger is set on a table , the trigger happens on a particular table when a operation occurs then it states a new action to happen which is an update in our case-
on BookCopy
after Insert
as 


begin
--body of trigger specifes the resulting action--
declare @ISBN varchar(13);

select @ISBN = ISBN
from inserted;

update Book
set NumberOfCopiesOwned = NumberOfCopiesOwned +1
where ISBN = @ISBN


 --created tables--
 --trigger event on insert,update,delete--

 


 end 