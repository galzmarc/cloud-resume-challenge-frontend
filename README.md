# Cloud Resume Challenge - Frontend

This repository contains the frontend code for my submission to the Cloud Resume Challenge. It showcases a serverless web application built using AWS services.

## Overview

The frontend is developed using various AWS services, such as S3, CloudFront, Route53 and Certificate Manager. It interacts with the backend APIs hosted on AWS. The application features a static website and a visitor counter.

I have chosen vanilla Javascript to connect the frontend and the backend, as IMHO it did not make sense to use any framework due to the simple operations performed.

Everything is deployed using IaC with Terraform.

## Technologies Used

- HTML, CSS: To create and style the website
- JavaScript: Consitutes the integration between frontend and backend though API Gateway. Fetches the API Gateway endpoint with PUT and GET requests, called in sequence. It basically increases by one the visits counter, and then it displays the updated counter on the page. 
- S3: Hosts the static files for the website
- CloudFront: Used to serve the static website hosted on S3. Redirects HTTP requests to HTTPS for increased security.
- Route53 and Certificate Manager: Used for DNS and to point requests to CloudFront.
- Terraform: Used to deploy the frontend with IaC.
- GitHub Actions: For CI/CD, re-deploys the frontend when any file is modified.

## Resources

- The final result: https://galzmarc.com
- Backend repository: https://github.com/galzmarc/cloud-resume-challenge-backend
- Cloud Resume Challenge official website: https://cloudresumechallenge.dev/docs/the-challenge/aws/