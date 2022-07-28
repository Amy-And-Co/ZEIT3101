# System Security
## Project Aim 
We aim to discover and analyse threats that may be encountered through deploying a simple phoenix application through fly.io so the client have a clear view on any risks and mitigations for their own deployment. 

## Project Scope  

The client has developed a phoenix application and wish to deploy this using fly.io. However, as the application utilises many new technologies (Phoenix, Phoenix LiveView), the client wishes to be aware of any risks they may face when deploying this application. Our task would be to create a prototype application with various pages and the same authentication scripts as the client application. We would then deploy this prototype and conduct threat analysis of the application, including mapping the threat surface, conducting penetration and fuzz testing, and looking at flaws in the framework. After this point, the client has made available two different paths that we can follow once the threat analysis is complete. The first options upon find a large bug in the framework, we can develop a fix and publish this online as an open-source fix for public awareness and as a contribution to the cyber security industry. The second option is if upon having a solid deployment, we can explore integrating 2FA, Universal 2nd Factor and account recovery features to our prototype. 

## Project Deliverables 

Prototype Phoenix LiveView application with authentication deployed on fly.io with appropriate documentation 
Report with threat analysis conducted on application 
Either: 
  A fix to a large bug discovered in the Phoenix framework to be published online 
  Research and attempted integration of 2FA, U2F an account recovery features to the Phoenix application 
