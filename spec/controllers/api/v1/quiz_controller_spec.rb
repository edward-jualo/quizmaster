require 'rails_helper'

RSpec.describe Api::V1::QuizController, type: :controller do
  
  describe "#random" do
    context "when GET request come to /random" do
      it "response with 200" do
        get :random, format: :json
        expect(response.status).to eq(200)
      end
      
      it "renders a random question" do
        get :random, format: :json
        expect(JSON(response.body)).not_to be_empty
        expect(Question.find(JSON(response.body)["id"])).not_to be_nil
      end
    end
  end
  
  describe "#check_answer" do
    context "when POST request come to /check_answer" do
      it "checks for the answer to be true" do
        random_question = Question.all.sample
        post :check_answer, id: random_question.id, :answer => "#{random_question.answer}", format: :json
        
        expect(response.status).to eq(200)
        expect(JSON(response.body)["status"]).to be_truthy
      end
      
      it "handles for wrong answer" do
        random_question = Question.all.sample
        post :check_answer, id: random_question.id, :answer => "xxx", format: :json
        
        expect(response.status).to eq(200)
        expect(JSON(response.body)["status"]).to be_falsey
      end
      
      it "humanizes user input" do
        random_question = Question.all.sample
        post :check_answer, id: random_question.id, :answer => "#{NumbersInWords.in_words(random_question.answer.to_i)}", format: :json
        
        expect(response.status).to eq(200)
        expect(JSON(response.body)["status"]).to be_truthy
      end
    end
  end
end
