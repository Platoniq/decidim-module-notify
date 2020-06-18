# frozen_string_literal: true

shared_examples "model component is notify" do
  it "is associated with a component" do
    expect(subject.component).to be_a(Decidim::Component)
  end

  context "when component is not notify" do
    let(:another_component) { create :dummy_component }

    before do
      subject.component = another_component
    end

    it { is_expected.to be_invalid }
  end

  context "when obtaining all elements for the component" do
    it "returns current element" do
      expect(subject.class.for(subject.component)).to include(subject)
    end
  end
end
