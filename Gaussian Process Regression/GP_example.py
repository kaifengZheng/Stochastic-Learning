import numpy as np
from numpy import transpose as T
from matplotlib import pyplot as plt
from sklearn.gaussian_process import GaussianProcessRegressor
from sklearn.gaussian_process.kernels import RBF, ConstantKernel as C
np.random.seed(1)

def f(x):
    return x * np.sin(x)
X = T(np.atleast_2d([1.,3.,5.,6.,7.,8.,10.]))
y = np.ravel(f(X))
x = T(np.atleast_2d(np.linspace(0,10,1000)))

kernel = C(1.0,(1e-13,1e3))*RBF(10,(1e-2,1e2))
gp = GaussianProcessRegressor(kernel=kernel,n_restarts_optimizer=9)
gpfit = gp.fit(X,y)
y_pred, sigma = gp.predict(x,return_std=True)

plt.figure()
plt.plot(x,f(x),'r:',label=r'$f(x)=x\,\sin(x)$')
plt.plot(X,y,'r.',markersize=10,label=u'Observations')
plt.plot(x,y_pred,'b-',label=u'Prediction')
plt.fill(np.concatenate([x,x[::-1]]),
         np.concatenate([y_pred-1.9600*sigma,
                         (y_pred+1.9600*sigma)[::-1]]),
         alpha = .5, fc='b',ec='None',label='95% confidence interval')
plt.xlabel('$x$')
plt.ylabel('$f(x)$')
plt.ylim(-10,20)
plt.legend(loc='upper left')
plt.show()


