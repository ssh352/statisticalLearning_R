
#calculate test error rates for classifiers Linear Regression, Logistic Regression, QDA and KNN 
library(ISLR)
summary(Weekly)

#get the pairs
pairs(Weekly)

cor(Weekly[,-9])

#perform Logistic Regression
attach(Weekly)
glm.fit = glm(Direction~Lag1+Lag2+Lag3+Lag4+Lag5+Volume, data=Weekly, family=binomial)
summary(glm.fit)

#compute the confusion matrix
glm.probs = predict(glm.fit, type = "response")
glm.pred = rep("Down", length(glm.probs))
glm.pred[glm.probs > 0.5] = "Up"
table(glm.pred, Direction)


train = (Year < 2009)
Weekly.0910 = Weekly[!train,]
glm.fit = glm(Direction ~Lag2, data=Weekly, family=binomial, subset=train)
glm.probs = predict(glm.fit, Weekly.0910, type = "response")
glm.pred = rep("Down", length(glm.probs))
glm.pred[glm.probs > 0.5] = "Up"
Direction.0910 = Direction[!train]
table(glm.pred, Direction.0910)

mean(glm.pred == Direction.0910)


######use LDA
library(MASS)
lda.fit = lda(Direction ~ Lag2, data=Weekly, subset=train)
lda.pred = predict(lda.fit, Weekly.0910)
table(lda.pred$class, Direction.0910)

mean(lda.pred$class == Direction.0910)

#####use QDA
qda.fit = qda(Direction ~ Lag2, data=Weekly, subset=train)
qda.class = predict(qda.fit, Weekly.0910)$class
table(qda.class, Direction.0910)

mean(qda.class == Direction.0910)


#use KNN (k=1)
library(class)
train.X = as.matrix(Lag2[train])
test.X = as.matrix(Lag2[!train])
train.Direction = Direction[train]
set.seed(1)
knn.pred = knn(train.X, test.X, train.Direction, k=1)
table(knn.pred, Direction.0910)

mean(knn.pred == Direction.0910)


#logistic regression with Lag2:Lag1
glm.fit = glm(Direction ~ Lag2:Lag1, data = Weekly, family = binomial, subset = train)
glm.probs = predict(glm.fit, Weekly.0910, type = "response")
glm.pred = rep("Down", length(glm.probs))
glm.pred[glm.probs > 0.5] = "Up"
Direction.0910 = Direction[!train]
table(glm.pred, Direction.0910)

mean(glm.pred == Direction.0910)

#LDA with Lag2 interaction with Lag1
lda.fit = lda(Direction ~ Lag2:Lag1, data = Weekly, subset = train)
lda.pred = predict(lda.fit, Weekly.0910)
mean(lda.pred$class == Direction.0910)

#QDA with sqrt(abs(Lag2))
qda.fit = qda(Direction ~ Lag2 + sqrt(abs(Lag2)), data = Weekly, subset = train)
qda.class = predict(qda.fit, Weekly.0910)$class
table(qda.class, Direction.0910)

mean(qda.class == Direction.0910)


#kNN with k= 10
knn.pred = knn(train.X, test.X, train.Direction, k = 10)
table(knn.pred, Direction.0910)

mean(knn.pred == Direction.0910)

#kNN with k=100
knn.pred = knn(train.X, test.X, train.Direction, k = 100)
table(knn.pred, Direction.0910)

mean(knn.pred == Direction.0910)

#overall Logistic Regression seems the best classifier according to the test scores
