# -*- encoding : utf-8 -*-
module BraspagRest
  class Fare < Hashie::IUTrash
    property :mdr, from: 'Mdr'
    property :fee, from: 'Fee'
  end
end
