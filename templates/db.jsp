<%@ page language="java"  %>
--
-- CodePamoja Sample Table

--
-- It is important that you leave the provided table_name as is

-- EDIT THIS BEFORE YOU CLICK SAVE OTHERWISE USE SQL TO UPDATE THE TABLE STRUCTURE 

CREATE TABLE <%= request.getParameter("uid").replaceAll("@","_") %>_<%= request.getParameter("test") %>
(
  id bigserial NOT NULL,
  q text,
  a text
)
