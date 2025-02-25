% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/odds_ratio.R
\name{odds_ratio}
\alias{odds_ratio}
\title{Analyzes a data frame to give an odds ratio}
\usage{
odds_ratio(exposure, outcome, covariates = NULL, df)
}
\arguments{
\item{exposure}{Character value. The name of a column in a data frame that represents exposure in an}

\item{outcome}{Character value. The name of a \strong{binary} column in a data frame that represents the outcome.}

\item{covariates}{Character value/vector. The name(s) of the columns that the user wants adjust on.}

\item{df}{The data frame for analysis}
}
\value{
A six column data frame with the following summary statistics:
\itemize{
\item odds ratio
\item beta (log odds)
\item lower 95\% confidence interval of beta coefficient
\item upper 95\% confidence interval of beta coefficient
\item p value
\item number of samples in the dataset
}
}
\description{
runs a logistic regression of with the following parameters order like so: outcome ~ exposure + covariates.
}
\examples{
#creates the causal diagram
confounder_dag = HydeNetwork(~B|A + C|A + D|B*C)

#adds set effect sizes and distributions to the causal diagram
confounder_dag = setNode(my_dag, A, nodeType = "dbern", prob = 0.5)
confounder_dag = setNode(my_dag, B, nodeType = "dnorm", mu = paste0(1," * A + ",0 - 1*0.5), tau = 1)
confounder_dag = setNode(my_dag, C, nodeType = "dbern", prob = paste0("ilogit(",0.8," * A + ",set_p(0.1, 0.8*0.5),")"))
confounder_dag = setNode(my_dag, D, nodeType = "dbern", prob = paste0("ilogit(",0.05," * B + ", 1.2," * C + ",set_p(0.25, 1.2 * 0.1 + 0.05 * 0 ),")"))

#create data creates a single dataset.
#This lets users see if the simulated datasets behave as expected before committing to a large simulation with many iterations

sim_data = create_data(confounder_dag, 10000)

#outcome must be binary
or_result = odds_ratio(exposure = "A", outcome = "D", covariates = c("B","C"), df = sim_data)
rr_result = risk_ratio(exposure = "A", outcome = "D", covariates = c("B","C"), df = sim_data)

#outcome must be continuous
lm_results = lm_beta(exposure = "C", outcome = "B", covariates = "A", df = sim_data)

#outcome may be either
ps_df = get_ps(exposure = "C", covariates = "A", df = sim_data)
ps_results = ps_weight(exposure = "C", outcome = "B", covariates = "A", df = ps_df, weights = "weights")
}
\seealso{
\code{\link[=varied_runs]{varied_runs()}},\code{\link[=apply_methods]{apply_methods()}}
}
