function [confidence]= SVMTesting(model,features)

[prediction, score]= predict(model, features);

confidence = score(:, 2);

end