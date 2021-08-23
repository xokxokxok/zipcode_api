require 'rails_helper'

RSpec.describe ZipCodeFinder do
  fixtures :users, :addresses

  let(:user) { users.first }
  let(:address) { addresses.first }
  let(:zip_code) { '12345678' }
  let(:zip_code_details) { {
    zip_code: "04209003",
    address: "Rua do Manifesto de 2401/2402 ao fim",
    neighborhood: "Ipiranga",
    city: "São Paulo",
    state: "SP",
    country: "Brasil"
  } }

  describe '.call' do
    it 'instanciates the class and calls method #call' do
      call = double(:call)
      expect(call).to receive(:call)
      expect(described_class).to receive(:new).with(zip_code).and_return(call)

      described_class.call(zip_code)
    end
  end

  describe '#call' do
    context 'when zip is invalid' do
      it 'returns nil' do
        expect(described_class.new('zip123').call).to be_nil
      end
    end

    context 'when zip is valid' do
      context 'is already cached by rails' do
        let!(:subject) { described_class.new(zip_code) }

        it 'returns cached' do
          Rails.cache.write("#{zip_code}/finder", address, expires_in: 10.seconds)

          expect(subject).to_not receive(:get_zip_code_from_database)
          expect(subject).to_not receive(:get_zip_code_from_api)

          expect(subject.call).to eq address
        end
      end

      context 'is already saved at database but not cached' do
        let!(:subject) { described_class.new(address.zip_code) }

        it 'returns from database' do
          Rails.cache.delete("#{address.zip_code}/finder")

          expect(subject).to_not receive(:get_zip_code_from_api)

          expect(subject.call).to eq address
        end
      end

      context 'is not saved or cached' do
        let!(:subject) { described_class.new('04209003') }

        before do
          expect(ZipCodeClients::ViaCep).to receive(:get_zip_code_details).and_return(zip_code_details)
        end

        it 'returns from database' do
          Rails.cache.delete('04209003/finder')

          allow(subject).to receive(:get_zip_code_from_database).and_return(false)

          address = subject.call
          expect(address.zip_code).to eq "04209003"
          expect(address.address).to eq "Rua do Manifesto de 2401/2402 ao fim"
          expect(address.neighborhood).to eq "Ipiranga"
          expect(address.city).to eq "São Paulo"
          expect(address.state).to eq "SP"
          expect(address.country).to eq "Brasil"
        end
      end
    end
  end
end
