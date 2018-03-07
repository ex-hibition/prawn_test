require 'spec_helper'

describe CreatePDF do
  let(:line) { line = ["test-id","test-name","test-address","test-tel","test_course","test-campaign"] }
  let(:idx) { idx = 1}
  let(:pdf) { CreatePDF.new }

  describe '#importOrder' do
    subject { pdf.importOrder(line: line, idx: idx) }
    it '構造化されたOrderを返す' do
      is_expected.to have_attributes(num: 1, id: "test-id", name: "test-name", address: "test-address", tel: "test-tel", course: "test_course", campaign: "test-campaign")
    end
  end
  
end